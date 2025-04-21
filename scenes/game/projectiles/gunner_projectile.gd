extends Area2D

var age = 0
var velocity = Vector2(0, 0)

func _process(delta):
	position += velocity * delta
	age += delta
	if age >= 2:
		queue_free()

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		body.stun_duration = 3
		queue_free()
	elif body.name.begins_with("Fence"):
		body.damage(20)
