class_name Bunny extends CharacterBody2D
@export var player: CharacterBody2D
@export_group("Movement Properties")
@export var scared_speed = 100
@export var scared_radius = 75
@export var scared_accel = 40
@export var hop_delay = 5
@export var hop_speed = 60
@export var hop_duration = 2.5

enum BunnyState {FREE, HOPPING, SCARED, ENTERING, EXITING, TRAPPED, GRABBED}

var state = BunnyState.FREE
var idle_timer = 0 # time spent in FREE between hops
var hop_timer = 0 # time spent in current hop
var hop_direction # direction of current hop
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

func process_free(delta):
	if position.distance_to(player.position) <= scared_radius:
		state = BunnyState.SCARED
		return
	idle_timer += delta
	if idle_timer >= hop_delay:
		idle_timer = 0
		hop_direction = Vector2.from_angle(randf() * TAU) # choose a random angle between 0 and tau radians to hop in
		state = BunnyState.HOPPING

func process_hopping(delta):
	var t = hop_timer / hop_duration
	var speed = (t - t*2) * hop_speed # should be cubic ease in out
	velocity = hop_direction * speed
	hop_timer += delta
	move_and_slide()
	if hop_timer >= hop_duration:
		state = BunnyState.FREE
		velocity = Vector2(0,0)
		hop_timer = 0

func process_scared(delta):
	if position.distance_to(player.position) >= scared_radius * 1.02:
		state = BunnyState.FREE
		return
	if run_speed < scared_speed:
		run_speed += scared_accel * delta
		if run_speed > scared_speed:
			run_speed = scared_speed
	var direction = -position.direction_to(player.position)
	velocity = direction * run_speed
	move_and_slide()

func process_entering(delta):
	pass

func process_exiting(delta):
	pass

func process_trapped(delta):
	pass

func process_grabbed(delta):
	pass
