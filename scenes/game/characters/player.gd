extends CharacterBody2D
@export var speed = 100
@export var boombox_cooldown = 10
@export var dash_speed = 300
@export var dash_duration = 0.7
@export var dash_cooldown = 5
var boombox_projectile = preload("res://scenes/game/projectiles/BoomboxProjectile.tscn")
var time_since_boombox = boombox_cooldown
var time_since_dash = dash_cooldown
var dashing = false
var direction: Vector2

func _process(delta):
	time_since_boombox += delta
	time_since_dash += delta
	if Input.is_action_just_pressed("ability1") and time_since_boombox >= boombox_cooldown:
		add_child(boombox_projectile.instantiate())
		time_since_boombox = 0
	
	if Input.is_action_just_pressed("jump") and time_since_dash >= dash_cooldown:
		dashing = true
		time_since_dash = 0
	
	if dashing:
		velocity = direction * dash_speed
		if time_since_dash >= dash_duration:
			dashing = false
	else:
		direction = Vector2(
	   	 Input.get_action_strength("right") - Input.get_action_strength("left"),
	   	 Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
		velocity = direction * speed
	move_and_slide()
