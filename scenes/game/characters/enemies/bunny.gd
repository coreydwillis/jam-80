extends CharacterBody2D
@export var speed = 100
@export var scared_radius = 75
@export var player: CharacterBody2D

func _process(_delta):
	if position.distance_to(player.position) <= scared_radius:
		var direction = -position.direction_to(player.position)
		velocity = direction * speed
		move_and_slide()
