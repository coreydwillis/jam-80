extends Node2D
@export var player: CharacterBody2D
@export var centering_factor: Vector2
@export var player_weight = 0.5
@onready var viewport: Viewport = get_viewport()

func _process(delta):
	viewport.canvas_transform = Transform2D(0, -player.position * player_weight + centering_factor)
