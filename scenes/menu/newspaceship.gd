extends Sprite2D

@export var move_speed = 200
@export var target_position1 : Vector2 = Vector2(2000, 1500)
@export var target_position2 : Vector2 = Vector2(-500, -500)
var going_right: bool = true
var start_moving: bool = false

func _ready():
	global_position.x = -300
	global_position.y = -300
	SignalBus.splash_done.connect(start_moving_func)

func _process(delta):
	if start_moving:
		if going_right:
			global_position = global_position.move_toward(target_position1, move_speed * delta)
		else:
			global_position = global_position.move_toward(target_position2, move_speed * delta)
	if global_position.x == 2000:
		going_right = false
	if global_position.x == -500:
		going_right = true

func start_moving_func():
	start_moving = true

func _on_texture_button_pressed():
	$"../EasterEgg".visible = true
