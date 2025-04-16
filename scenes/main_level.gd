extends Node2D
@export var centering_factor: Vector2
@export var player_weight = 0.5
@onready var viewport: Viewport = get_viewport()
@onready var player = $"World/Player"
@onready var ui = $"Debug UI"
#var night_shader: Material
#var day_shader: Material

func _ready():
	SignalBus.day_started.connect(night_shader_disable)
	SignalBus.night_started.connect(night_shader_enable)

func _process(_delta):
	var offset = -player.position * player_weight + centering_factor
	viewport.canvas_transform = Transform2D(0, offset)

func _on_save_btn_test_pressed():
	SaveLoad.contents_to_save.days = 1
	SaveLoad.contents_to_save.runs = 1
	SaveLoad.contents_to_save.longest_run = 1
	SaveLoad._save()

func night_shader_enable():
	material.set_shader_parameter("light_mul", 0.4)

func night_shader_disable():
	material.set_shader_parameter("light_mul", 1.0)
