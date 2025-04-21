class_name Bunny extends CharacterBody2D
@export var speed_mul = 1.0
@export var delay_mul = 1.0
@export var scared_radius = 75
@export var escape_chance = 0.4
@export_group("Behavior")
@export var scared_speed = 100 # max speed while scared
@export var scared_accel = 40 # acceleration while scared
@export var hop_delay = 5 # delay between hops in seconds
@export var hop_speed = 60 # top speed while hopping
@export var hop_duration = 2.5 # hop duration in seconds
@export var enter_speed = 40 # speed while entering pen
@export var enter_duration = 0.7 # time it takes to enter pen
@export var escape_delay = 2.5 # time between escape attempts in seconds
@export var escape_speed = 60 # speed when attempting escape
@export var roam_speed = 30 # speed while roaming in the pen
@export var roam_on_duration = 0.4 # seconds moving per roam cycle
@export var roam_off_duration = 0.3 # seconds still per roam cycle

@onready var animator = $AnimatedSprite2D
@onready var bunny_sounds = $BunnySounds

# Sprite Frame
var sprite_frames : SpriteFrames

# Sound files
const BUNNY_SCREAM = preload("res://assets/audio/sfx/rabbits/Bunny Scream.wav")
const BUNNY_CONTENT = preload("res://assets/audio/sfx/rabbits/Bunny Contentment.wav")
const BUNNY_GRR = preload("res://assets/audio/sfx/rabbits/Bunny Grr.wav")
const BUNNY_GROWL = preload("res://assets/audio/sfx/rabbits/Monster Growl.wav")
const MONSTER_JUMP = preload("res://assets/audio/sfx/rabbits/Monster Jump.wav")
const BUNNY_BITE = preload("res://assets/audio/sfx/rabbits/MonsterBite.wav")
const BUNNY_SCRAPE = preload("res://assets/audio/sfx/rabbits/MonsterScrape.wav")
const BUNNY_BOUNCE = preload("res://assets/audio/sfx/rabbits/Rabbit Bounce.wav")
const BUNNY_STUNNED = preload("res://assets/audio/sfx/abilities/Electricity Zap.wav")
const BUNNY_MAGIC = preload("res://assets/audio/sfx/abilities/Magic Whoosher.wav")
const BUNNY_BULLET = preload("res://assets/audio/sfx/abilities/magic2.wav")

@onready var ray = $RayCast2D
@onready var player = $"/root/Main/World/Player"

const GUNNER_PROJECTILE = preload("res://scenes/game/projectiles/gunner_projectile.tscn")

enum BunnyState {
	NULL,		# should never show up
	FREE,		# out of pen, not moving (> HOPPING, SCARED)
	HOPPING,	# out of pen, hopping (> FREE)
	SCARED,		# out of pen, running from player (> FREE, ENTERING)
	ENTERING,	# jumping into pen (> TRAPPED, HEALING)
	EXITING,	# jumping out of pen (> FREE)
	ESCAPING,	# in pen, attempting escape (> TRAPPED, EXITING)
	TRAPPED,	# in pen, roaming (> ESCAPING)
	STUNNED,	# affected by player's ability (> FREE, TRAPPED)
	SLEEPING	# sleeping during the night (> ESCAPING)
}

enum BunnyType {
	BASIC,		# basic bunny, no special effects (breeds into other bunnies)
	KILLER,		# stuns player on contact, gives 2x eggs
	BUFF,		# damages fences, especially on failed escapes, kb/stun resistance. gives 2x eggs
	MAGIC,		# teleports instead of hopping, gives 3x eggs
	GUNNER,		# shoots projectiles that stun player and damage fences, gives 3x eggs
	HYPER,		# moves faster, hops more often, escapes easier, gives 3x eggs
	GOLDEN		# basic bunny but gives 5x eggs (never reproduces)
}

var states_dict = {
	BunnyState.FREE: StateFree.new(self),
	BunnyState.HOPPING: StateHopping.new(self),
	BunnyState.SCARED: StateScared.new(self),
	BunnyState.ENTERING: StateEntering.new(self),
	BunnyState.EXITING: StateExiting.new(self),
	BunnyState.ESCAPING: StateEscaping.new(self),
	BunnyState.TRAPPED: StateTrapped.new(self),
	BunnyState.STUNNED: StateStunned.new(self),
	BunnyState.SLEEPING: StateSleeping.new(self)
}
const IN_PEN_STATES = [BunnyState.TRAPPED, BunnyState.ENTERING, BunnyState.EXITING, BunnyState.ESCAPING, BunnyState.SLEEPING]

var state_id = BunnyState.NULL
var state_obj = State.new(self)
var timer = 0 # time spent in current state
var direction = Vector2(0, 1) # direction of current movement
var speed = 0 # speed of current movement
var type: BunnyType
var bullet_timer = 0 # only used for gunner

func _ready():
	Game.total_bunnies += 1
	SignalBus.day_started.connect(stop_sleeping)
	SignalBus.night_started.connect(start_sleeping)
	init(BunnyState.ESCAPING, BunnyType.BASIC)

func _process(delta):
	state_obj._process(delta)
	velocity = speed * direction
	timer += delta
	if direction.x < 0:
		animator.flip_h = false
	elif direction.x > 0:
		animator.flip_h = true
	if Game.is_day and type == BunnyType.GUNNER:
		bullet_timer += delta
		if bullet_timer >= 4:
			bullet_timer = 0
			var bullet = GUNNER_PROJECTILE.instantiate()
			$ShootSound.set_stream(BUNNY_BULLET)
			$ShootSound.volume_db = 0.1
			$ShootSound.volume_linear = 0.1
			$ShootSound.play()
			$"/root/Main".add_child(bullet)
			bullet.position = position
			bullet.velocity = position.direction_to(player.position) * 200
	move_and_slide()
	for c in range(get_slide_collision_count()):
		process_collision(get_slide_collision(c).get_collider())

func init(s: BunnyState, t: BunnyType):
	switch_state(s)
	type = t
	#modulate = Game.bunny_colors[type]
	match type:
		BunnyType.KILLER:
			sprite_frames = preload("res://scenes/game/characters/enemies/bunny_bloody.tres")
			animator.sprite_frames = sprite_frames
			animator.play()
			scared_radius *= 0.75
			scared_speed *= 0.75
			scared_accel *= 0.75
		BunnyType.BUFF:
			sprite_frames = preload("res://scenes/game/characters/enemies/bunny_alien.tres")
			animator.sprite_frames = sprite_frames
			animator.play()
			speed_mul = 0.7
			delay_mul = 1.2
		BunnyType.MAGIC:
			sprite_frames = preload("res://scenes/game/characters/enemies/bunny_tophat.tres")
			animator.sprite_frames = sprite_frames
			animator.play()
			delay_mul = 2
		BunnyType.GUNNER:
			sprite_frames = preload("res://scenes/game/characters/enemies/bunny_anthro.tres")
			animator.sprite_frames = sprite_frames
			animator.play()
		BunnyType.HYPER:
			sprite_frames = preload("res://scenes/game/characters/enemies/bunny_alien.tres")
			animator.sprite_frames = sprite_frames
			animator.play()
			speed_mul = 1.7
			delay_mul = 0.7
			escape_chance *= 1.5
			scared_radius *= 1.25
	calc_behavior()

func calc_behavior():
	scared_speed *= speed_mul
	scared_accel *= speed_mul
	hop_delay *= delay_mul
	hop_speed *= speed_mul
	enter_speed *= speed_mul
	enter_duration /= speed_mul
	escape_delay *= delay_mul
	escape_speed *= speed_mul
	roam_speed *= speed_mul
	roam_on_duration /= delay_mul
	roam_off_duration *= delay_mul

func is_in_pen():
	return abs(position.x) <= Game.pen_radius and abs(position.y) <= Game.pen_radius

func process_collision(collider):
	if collider.name.begins_with("Fence"):
		if state_id == BunnyState.ESCAPING:
			if collider.is_broken or randf() < escape_chance - collider.escape_reduction:
				switch_state(BunnyState.EXITING)
			else:
				if type == BunnyType.BUFF:
					collider.damage(20)
					$ShootSound.set_stream(BUNNY_SCRAPE)
					$ShootSound.volume_db = 0.2
					$ShootSound.volume_linear = 0.2
					$ShootSound.play()
					if collider.is_broken:
						switch_state(BunnyState.EXITING)
						return
				switch_state(BunnyState.TRAPPED)
		elif not is_in_pen():
			switch_state(BunnyState.ENTERING)
	elif collider.name == "Player":
		if type == BunnyType.KILLER:
			collider.stun_duration = 5
		elif state_id == BunnyState.HOPPING:
			switch_state(BunnyState.SCARED)

func switch_state(new_state: BunnyState):
	timer = 0
	state_obj._exit()
	if state_id in IN_PEN_STATES: Game.bunnies_in_pen -= 1
	if new_state in IN_PEN_STATES: Game.bunnies_in_pen += 1
	SignalBus.bunny_count_change.emit()
	state_id = new_state
	state_obj = states_dict[state_id]
	state_obj._enter()

func point_to_center(reverse=false):
	var d = position.direction_to(Game.centerpoint)
	if reverse: d = -d
	direction = d

func point_random(): # choose a random angle between 0 and tau radians to point in
	var collided_with_fence = true
	var angle = 0
	while collided_with_fence:
		collided_with_fence = false
		angle = randf() * TAU
		ray.rotation = angle
		ray.force_raycast_update()
		if ray.is_colliding():
			if ray.get_collider().name.begins_with("Fence"):
				collided_with_fence = true
	direction = Vector2.from_angle(angle)

class State:
	var state: BunnyState
	var bunny: Bunny
	func _init(b: Bunny):
		state = BunnyState.NULL
		bunny = b
	func _exit():
		pass
	func _enter():
		pass
	func _process(_delta):
		pass

class StateFree extends State:
	func _init(b: Bunny):
		state = BunnyState.FREE
		bunny = b
	func _enter():
		bunny.speed = 0
		bunny.bunny_sounds.set_stream(BUNNY_CONTENT)
		bunny.bunny_sounds.play()
		bunny.set_animation("idle_side")
	func _process(_delta):
		if bunny.position.distance_to(bunny.player.position) <= bunny.scared_radius:
			bunny.switch_state(BunnyState.SCARED)
		elif bunny.timer >= bunny.hop_delay:
			bunny.switch_state(BunnyState.HOPPING)

class StateHopping extends State:
	func _init(b: Bunny):
		state = BunnyState.HOPPING
		bunny = b
	func _enter():
		if bunny.type == BunnyType.KILLER:
			bunny.direction = bunny.position.direction_to(bunny.player.position)
		else:
			bunny.point_random()
		if bunny.type == BunnyType.MAGIC:
			bunny.position += bunny.direction * bunny.hop_speed * bunny.hop_duration
			bunny.switch_state(BunnyState.FREE)
		else:
			bunny.set_animation("run_side")
	func _process(_delta):
		if bunny.timer >= bunny.hop_duration:
			bunny.switch_state(BunnyState.FREE)
			return
		var t = bunny.timer / bunny.hop_duration
		bunny.speed = (t - t*2) * bunny.hop_speed # should be cubic ease in out, looks a bit subtle though

class StateScared extends State:
	func _init(b: Bunny):
		state = BunnyState.SCARED
		bunny = b
	func _enter():
		bunny.bunny_sounds.set_stream(BUNNY_SCREAM)
		bunny.bunny_sounds.play()
		bunny.set_animation("scared_side")
		await bunny.get_tree().create_timer(1).timeout
		bunny.set_animation("walk_side")
	func _process(delta):
		if bunny.position.distance_to(bunny.player.position) >= bunny.scared_radius * 1.02: # small buffer to prevent rapid switching
			bunny.switch_state(BunnyState.FREE)
			return
		if bunny.speed < bunny.scared_speed: # ramp up to max scared_speed
			bunny.speed += bunny.scared_accel * delta
			if bunny.speed > bunny.scared_speed:
				bunny.speed = bunny.scared_speed
		if bunny.player.carrot_duration > 0:
			bunny.direction = bunny.position.direction_to(bunny.player.position)
		else:
			bunny.direction = -bunny.position.direction_to(bunny.player.position)

class StateEntering extends State:
	func _init(b: Bunny):
		state = BunnyState.ENTERING
		bunny = b
	func _enter():
		bunny.point_to_center()
		bunny.speed = bunny.enter_speed
		bunny.collision_layer = 0
		bunny.collision_mask = 0
		bunny.set_animation("run_side")
	func _exit():
		bunny.collision_layer = 1
		bunny.collision_mask = 1
	func _process(_delta):
		if bunny.timer >= bunny.enter_duration:
			bunny.switch_state(BunnyState.TRAPPED)

class StateExiting extends State:
	func _init(b: Bunny):
		state = BunnyState.EXITING
		bunny = b
	func _enter():
		bunny.bunny_sounds.set_stream(BUNNY_BOUNCE)
		bunny.bunny_sounds.play()
		bunny.point_to_center(true)
		bunny.speed = bunny.enter_speed
		bunny.collision_mask = 0
		bunny.set_animation("run_side")
	func _exit():
		bunny.collision_mask = 1
	func _process(_delta):
		if bunny.timer >= bunny.enter_duration:
			bunny.switch_state(BunnyState.HOPPING)

class StateEscaping extends State:
	func _init(b: Bunny):
		state = BunnyState.ESCAPING
		bunny = b
	func _enter():
		bunny.bunny_sounds.set_stream(BUNNY_BOUNCE)
		bunny.bunny_sounds.play()
		if bunny.type == BunnyType.MAGIC:
			bunny.point_to_center(true)
			bunny.position += bunny.direction * 80
			bunny.bunny_sounds.set_stream(BUNNY_MAGIC)
			bunny.bunny_sounds.play()
			bunny.switch_state(BunnyState.FREE)
		else:
			bunny.point_random()
			bunny.speed = bunny.escape_speed
			bunny.set_animation("walk_side")

class StateTrapped extends State:
	var roam_timer = 0
	var roam_active = true
	func _init(b: Bunny):
		state = BunnyState.TRAPPED
		bunny = b
	func _enter():
		bunny.bunny_sounds.set_stream(BUNNY_GRR)
		bunny.bunny_sounds.play()
		bunny.point_to_center()
		roam_timer = 0
		roam_active = true
		bunny.set_animation("walk_side")
	func _process(delta):
		if bunny.timer >= bunny.escape_delay:
			bunny.switch_state(BunnyState.ESCAPING)
			return
		roam_timer += delta
		if roam_active and roam_timer >= bunny.roam_on_duration:
			roam_active = false
			bunny.speed = 0
			roam_timer = 0
		elif !roam_active and roam_timer >= bunny.roam_off_duration:
			roam_active = true
			bunny.point_random()
			bunny.speed = bunny.roam_speed
			roam_timer = 0

class StateStunned extends State:
	var knockback_strength = 0
	var knockback_decay = 0
	var stun_duration = 0
	func _init(b: Bunny):
		state = BunnyState.STUNNED
		bunny = b
	func _enter():
		bunny.bunny_sounds.set_stream(BUNNY_STUNNED)
		bunny.bunny_sounds.play()
		bunny.set_animation("idle_side")
	
	func _process(delta):
		var sd = stun_duration
		if bunny.type == BunnyType.BUFF: sd /= 2.0
		if bunny.timer >= sd:
			if bunny.is_in_pen():
				bunny.switch_state(BunnyState.TRAPPED)
			else:
				bunny.switch_state(BunnyState.FREE)
			return
		var kb = knockback_strength
		if bunny.type == BunnyType.BUFF: kb /= 2.0
		if kb > 0:
			bunny.speed = kb
			knockback_strength -= delta * knockback_decay

class StateSleeping extends State:
	func _init(b: Bunny):
		state = BunnyState.SLEEPING
		bunny = b
	func _enter():
		bunny.set_animation("sleep_side")
		bunny.speed = bunny.roam_speed
		bunny.point_random()
	func _process(_delta):
		if bunny.speed > 0 and bunny.timer >= bunny.roam_on_duration * 2:
			bunny.speed = 0

func start_sleeping():
	if state_id in IN_PEN_STATES:
		switch_state(BunnyState.SLEEPING)
		Game.eggs += Game.egg_rates[type]
		SignalBus.egg_count_change.emit()
	else:
		Game.total_bunnies -= 1
		queue_free()

func stop_sleeping():
	switch_state(BunnyState.ESCAPING)

func set_animation(currentAnimation: String):
	animator.play(currentAnimation)
