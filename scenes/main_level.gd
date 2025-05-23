extends Node2D
@export var centering_factor: Vector2
@export var player_weight = 0.5
@onready var viewport: Viewport = get_viewport()
@onready var player = $"World/Player"
@onready var pause_menu_canvas = $PauseMenuCanvas

var pause_menu_scene = load("uid://dejeb358jsx7j")
var game_over_menu_scene = load("uid://cuxauu0yk4tcp")
var game_win_menu_scene = load("uid://ci2p2maigufey")
var bazaar_scene = load("uid://ch8cw553ruqe8")
var bazaar_instance

func _ready():
	SignalBus.day_started.connect(night_shader_disable)
	SignalBus.day_started.connect(unload_bazaar)
	SignalBus.night_started.connect(night_shader_enable)
	SignalBus.night_started.connect(increase_requirement)
	SignalBus.night_started.connect(load_bazaar)
	SignalBus.check_win.connect(check_win_condition)
	SignalBus.game_over.connect(game_over)
	SignalBus.game_win.connect(game_win)
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
	Game.bunnies_needed = Game.bunnies_needed * Game.bunnies_needed_inc

func night_shader_enable():
	material.set_shader_parameter("light_mul", 0.6)

func night_shader_disable():
	material.set_shader_parameter("light_mul", 1.0)

func game_over():
	var game_over_menu = game_over_menu_scene.instantiate()
	pause_menu_canvas.add_child(game_over_menu)
	
func game_win():
	var game_win_menu = game_win_menu_scene.instantiate()
	pause_menu_canvas.add_child(game_win_menu)
	
func load_bazaar():
	bazaar_instance = bazaar_scene.instantiate()
	$World/BazaarHolder.add_child(bazaar_instance)
	
func unload_bazaar():
	bazaar_instance.queue_free()

func check_win_condition():
	if Game.bunnies_in_pen >= Game.bunnies_needed:
		SignalBus.game_win.emit()
