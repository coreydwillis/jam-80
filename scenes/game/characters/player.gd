extends CharacterBody2D
@export var speed = 100

func _process(_delta):
	var direction = Vector2(
   	 Input.get_action_strength("right") - Input.get_action_strength("left"),
   	 Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	direction = direction.normalized()
	velocity = direction * speed
	#temporary code for player sprites
	move_and_slide()
