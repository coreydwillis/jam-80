class_name Bunny extends CharacterBody2D
@export var player: CharacterBody2D # point to the player
@export_group("Behavior")
@export var scared_speed = 100 # max speed while scared
@export var scared_radius = 75 # distance to player where bunny turns scared
@export var scared_accel = 40 # acceleration while scared
@export var hop_delay = 5 # delay between hops in seconds
@export var hop_speed = 60 # top speed while hopping
@export var hop_duration = 2.5 # hop duration in seconds
@export var enter_speed = 40 # speed while entering pen
@export var enter_duration = 0.7 # time it takes to enter pen
@export var centerpoint = Vector2(0,0) # point bunny hops to in pen
@export var escape_delay = 2 # time between escape attempts in seconds
@export var escape_speed = 60 # speed when attempting escape
@export var escape_chance = 0.4 # chance an escape attempt is successful

@onready var ray = find_child("RayCast2D")

enum BunnyState {
	FREE,		# out of pen, not moving (> HOPPING, SCARED)
	HOPPING,	# out of pen, hopping (> FREE)
	SCARED,		# out of pen, running from player (> FREE, ENTERING)
	ENTERING,	# jumping into pen (> TRAPPED)
	EXITING,	# jumping out of pen (> FREE)
	ESCAPING,	# in pen, attempting escape (> TRAPPED, EXITING)
	TRAPPED,	# in pen, not moving (> ESCAPING)
	GRABBED		# grabbed by player's ability (> FREE, TRAPPED)
}

var state = BunnyState.FREE
var timer = 0 # time spent in current state (when necessary)
var direction # direction of current movement (when necessary)
var run_speed = 0 # current speed, only used while scared

func _process(delta):
	match state:
		BunnyState.FREE:
			process_free(delta)
		BunnyState.HOPPING:
			process_hopping(delta)
		BunnyState.SCARED:
			process_scared(delta)
		BunnyState.ENTERING:
			process_entering(delta)
		BunnyState.EXITING:
			process_exiting(delta)
		BunnyState.TRAPPED:
			process_trapped(delta)
		BunnyState.GRABBED:
			process_grabbed(delta)
		_:
			print("Unknown BunnyState occurred and I don't know how to handle it! Halp! ", state)

func enter_free():
	state = BunnyState.FREE
func exit_free():
	timer = 0
func process_free(delta):
	if position.distance_to(player.position) <= scared_radius:
		exit_free()
		enter_scared()
		return
	timer += delta
	if timer >= hop_delay:
		exit_free()
		enter_hopping()

func enter_hopping():
	direction = Vector2.from_angle(randf() * TAU) # choose a random angle between 0 and tau radians to hop in
	state = BunnyState.HOPPING
func exit_hopping():
	velocity = Vector2(0,0)
	timer = 0
func process_hopping(delta):
	var t = timer / hop_duration
	var speed = (t - t*2) * hop_speed # should be cubic ease in out, looks a bit subtle though
	velocity = direction * speed
	timer += delta
	move_and_slide()
	if timer >= hop_duration:
		exit_hopping()
		enter_free()

func enter_scared():
	state = BunnyState.SCARED
func exit_scared():
	pass
func process_scared(delta):
	if position.distance_to(player.position) >= scared_radius * 1.02: # small buffer to prevent rapid switching
		exit_scared()
		enter_free()
		return
	if run_speed < scared_speed: # ramp up to max scared_speed
		run_speed += scared_accel * delta
		if run_speed > scared_speed:
			run_speed = scared_speed
	direction = -position.direction_to(player.position)
	velocity = direction * run_speed
	if move_and_slide(): # if collided
		for c in get_slide_collision_count():
			var collider = get_slide_collision(c).get_collider()
			if collider.name.begins_with("Fence"): # if we hit a fence (should be a better way to do this but idk)
				exit_scared()
				enter_entering()
				return

func enter_entering():
	state = BunnyState.ENTERING
	direction = position.direction_to(centerpoint)
	collision_layer = 0
	collision_mask = 0
func exit_entering():
	timer = 0
	collision_layer = 1
	collision_mask = 1
	velocity = Vector2(0,0)
func process_entering(delta):
	velocity = direction * enter_speed
	timer += delta
	move_and_slide()
	if timer >= enter_duration:
		exit_entering()
		enter_trapped()

func enter_exiting():
	state = BunnyState.EXITING
func exit_exiting():
	pass
func process_exiting(_delta):
	pass

func enter_escaping():
	state = BunnyState.ESCAPING
func exit_escaping():
	pass
func process_escaping(_delta):
	pass

func enter_trapped():
	state = BunnyState.TRAPPED
func exit_trapped():
	pass
func process_trapped(_delta):
	pass

func enter_grabbed():
	state = BunnyState.GRABBED
func exit_grabbed():
	pass
func process_grabbed(_delta):
	pass
