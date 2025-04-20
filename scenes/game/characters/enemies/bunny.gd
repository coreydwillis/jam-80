class_name Bunny extends CharacterBody2D
@export_group("Behavior")
@export var scared_speed = 100 # max speed while scared
@export var scared_radius = 75 # distance to player where bunny turns scared
@export var scared_accel = 40 # acceleration while scared
@export var hop_delay = 5 # delay between hops in seconds
@export var hop_speed = 60 # top speed while hopping
@export var hop_duration = 2.5 # hop duration in seconds
@export var enter_speed = 40 # speed while entering pen
@export var enter_duration = 0.7 # time it takes to enter pen
@export var escape_delay = 2.5 # time between escape attempts in seconds
@export var escape_speed = 60 # speed when attempting escape
@export var escape_chance = 0.4 # chance an escape attempt is successful
@export var roam_speed = 30 # speed while roaming in the pen
@export var roam_on_duration = 0.4 # seconds moving per roam cycle
@export var roam_off_duration = 0.3 # seconds still per roam cycle
@onready var animator = $AnimatedSprite2D
@onready var bunny_sounds = $BunnySounds

# Sound files
const BUNNY_SCREAM = preload("res://assets/audio/sfx/rabbits/Bunny Scream.wav")

@onready var ray = $RayCast2D
@onready var player = $"/root/Main/World/Player"

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
	RETREATING,	# health reduced to 0, retreating to pen (> ENTERING)
	HEALING,	# resting in pen before escape attempts (> TRAPPED)
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
	BunnyState.RETREATING: State.new(self),
	BunnyState.HEALING: State.new(self),
	BunnyState.SLEEPING: StateSleeping.new(self)
}
const IN_PEN_STATES = [BunnyState.TRAPPED, BunnyState.ENTERING, BunnyState.EXITING, BunnyState.ESCAPING, BunnyState.HEALING, BunnyState.SLEEPING]

var state_id = BunnyState.NULL
var state_obj = State.new(self)
var timer = 0 # time spent in current state
var direction = Vector2(0, 1) # direction of current movement
var speed = 0 # speed of current movement
var type: BunnyType

func _ready():
	Game.total_bunnies += 1
	SignalBus.day_started.connect(stop_sleeping)
	SignalBus.night_started.connect(start_sleeping)
	init(BunnyState.ESCAPING, BunnyType.BASIC)

func _process(delta):
	state_obj._process(delta)
	velocity = speed * direction
	move_and_slide()
	timer += delta
	if direction.x < 0:
		animator.flip_h = false
	elif direction.x > 0:
		animator.flip_h = true

func init(s: BunnyState, t: BunnyType):
	switch_state(s)
	type = t
	modulate = Game.bunny_colors[type]

func is_in_pen():
	return abs(position.x) <= Game.pen_radius and abs(position.y) <= Game.pen_radius

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
	direction = Vector2.from_angle(randf() * TAU)

func point_roaming():
	if position.distance_to(Game.centerpoint) <= Game.pen_radius / 2:
		point_random()
	else:
		point_to_center()

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
		print("A null state? in my bunny game? it's more likely than you think. free PC check")

class StateFree extends State:
	func _init(b: Bunny):
		state = BunnyState.FREE
		bunny = b
	func _enter():
		bunny.speed = 0
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
		bunny.point_random()
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
		bunny.direction = -bunny.position.direction_to(bunny.player.position)
		for c in range(bunny.get_slide_collision_count()):
			var collider = bunny.get_slide_collision(c).get_collider()
			if collider.name.begins_with("Fence"): # if we hit a fence (should be a better way to do this but idk)
				bunny.switch_state(BunnyState.ENTERING)
				return

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
		bunny.point_to_center(true)
		bunny.speed = bunny.enter_speed
		bunny.collision_mask = 0
		bunny.set_animation("run_side")
	func _exit():
		bunny.collision_mask = 1
	func _process(_delta):
		if bunny.timer >= bunny.enter_duration:
			bunny.switch_state(BunnyState.FREE)

class StateEscaping extends State:
	func _init(b: Bunny):
		state = BunnyState.ESCAPING
		bunny = b
	func _enter():
		bunny.point_random()
		bunny.speed = bunny.escape_speed
		bunny.set_animation("walk_side")
	func _process(_delta):
		for c in range(bunny.get_slide_collision_count()):
			var collider = bunny.get_slide_collision(c).get_collider()
			if collider.name.begins_with("Fence"): # if we hit a fence (should be a better way to do this but idk)
				if randf() < bunny.escape_chance:
					bunny.switch_state(BunnyState.EXITING)
				else:
					bunny.switch_state(BunnyState.TRAPPED)
				return

class StateTrapped extends State:
	var roam_timer = 0
	var roam_active = true
	func _init(b: Bunny):
		state = BunnyState.TRAPPED
		bunny = b
	func _enter():
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
			bunny.point_roaming()
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
		bunny.set_animation("idle_side")
	
	func _process(delta):
		if bunny.timer >= stun_duration:
			if bunny.is_in_pen():
				bunny.switch_state(BunnyState.TRAPPED)
			else:
				bunny.switch_state(BunnyState.FREE)
			return
		if knockback_strength > 0:
			bunny.speed = knockback_strength
			knockback_strength -= delta * knockback_decay
		for c in range(bunny.get_slide_collision_count()):
			var collider = bunny.get_slide_collision(c).get_collider()
			if collider.name.begins_with("Fence"): # if we hit a fence (should be a better way to do this but idk)
				bunny.switch_state(BunnyState.ENTERING)
				return

class StateSleeping extends State:
	func _init(b: Bunny):
		state = BunnyState.SLEEPING
		bunny = b
	func _enter():
		bunny.set_animation("sleep_side")
		bunny.speed = bunny.roam_speed
		bunny.point_roaming()
	func _process(_delta):
		if bunny.speed > 0 and bunny.timer >= bunny.roam_on_duration * 2:
			bunny.speed = 0

func start_sleeping():
	if state_id in IN_PEN_STATES:
		switch_state(BunnyState.SLEEPING)
	else:
		Game.total_bunnies -= 1
		queue_free()

func stop_sleeping():
	switch_state(BunnyState.ESCAPING)

func set_animation(currentAnimation: String):
	animator.play(currentAnimation)
