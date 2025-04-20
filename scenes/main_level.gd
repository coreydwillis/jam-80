extends Node2D
@export var centering_factor: Vector2
@export var player_weight = 0.5
@onready var viewport: Viewport = get_viewport()
@onready var player = $"World/Player"
@onready var pause_menu_canvas = $PauseMenuCanvas
@onready var end_night_button = $MainUI/EndNightButton


var pause_menu_scene = load("uid://dejeb358jsx7j")
var game_over_menu_scene = load("uid://cuxauu0yk4tcp")


func _ready():
	SignalBus.day_started.connect(night_shader_disable)
	SignalBus.night_started.connect(night_shader_enable)
	SignalBus.night_started.connect(increase_requirement)
	SignalBus.game_over.connect(game_over)
	SignalBus.night_started.connect(turn_on_night_button)
	SignalBus.main_level.emit()
	Game.game_started = true
	

func _process(_delta):
	var offset = -player.position * player_weight + centering_factor
	viewport.canvas_transform = Transform2D(0, offset)
	
	## Pause Menu ##
	# We can probably put this somewhere better later
	if Input.is_action_just_pressed("pause"):
		var pause_menu_instance = pause_menu_scene.instantiate()
		pause_menu_canvas.add_child(pause_menu_instance)

func _on_save_btn_test_pressed():
	SaveLoad.contents_to_save.days = 1
	SaveLoad.contents_to_save.runs = 1
	SaveLoad.contents_to_save.longest_run = 1
	SaveLoad._save()

func increase_requirement():
	Game.bunnies_needed = Game.bunnies_needed + Game.bunnies_needed_inc

func night_shader_enable():
	material.set_shader_parameter("light_mul", 0.4)

func night_shader_disable():
	material.set_shader_parameter("light_mul", 1.0)

func game_over():
	var game_over_menu = game_over_menu_scene.instantiate()
	pause_menu_canvas.add_child(game_over_menu)

func _on_end_night_pressed():
	SignalBus.day_started.emit()
	end_night_button.visible = false

func turn_on_night_button():
	end_night_button.visible = true
