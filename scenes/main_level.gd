extends Node2D
@export var centering_factor: Vector2
@export var player_weight = 0.5
@onready var viewport: Viewport = get_viewport()
@onready var player = $"World/Player"
@onready var ui = $"Debug UI"

func _process(_delta):
	var offset = -player.position * player_weight + centering_factor
	viewport.canvas_transform = Transform2D(0, offset)

func _on_save_btn_test_pressed():
	SaveLoad.contents_to_save.days = 1
	SaveLoad.contents_to_save.runs = 1
	SaveLoad.contents_to_save.longest_run = 1
	SaveLoad._save()


func start_sleeping() -> void:
	pass # Replace with function body.
