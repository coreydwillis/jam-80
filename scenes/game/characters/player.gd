extends CharacterBody2D
@export var speed = 100
@export var boombox_cooldown = 10
@export var dash_speed = 300
@export var dash_duration = 0.7
@export var dash_cooldown = 5
var boombox_projectile = preload("res://scenes/game/projectiles/BoomboxProjectile.tscn")
var time_since_boombox = boombox_cooldown
var time_since_dash = dash_cooldown
@onready var animator = $AnimatedSprite2D

var dashing = false
var direction: Vector2
var stunned = false
var stun_duration = 0

func _process(delta):
	time_since_boombox += delta
	time_since_dash += delta
	
	if not Game.is_day and Input.is_action_just_pressed("skip"):
		Game.is_day = true
		Game.days += 1
		SignalBus.day_started.emit()
	
	if stunned:
		stun_duration -= delta
		return
	
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
		var new_direction = Vector2(
	   	 Input.get_action_strength("right") - Input.get_action_strength("left"),
	   	 Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
		# redid the animations - nezumi
		if new_direction.length() > 0:
			if new_direction.x > 0:
				animator.play("walk_side")
				animator.flip_h = true
			elif new_direction.x < 0:
				animator.play("walk_side")
				animator.flip_h = false
			elif new_direction.y > 0:
				animator.play("walk_front")
				animator.flip_h = false
			else:
				animator.play("walk_back")
				animator.flip_h = false
		elif direction.length() > 0:
			if direction.x > 0:
				animator.play("idle_side")
				animator.flip_h = true
			elif direction.x < 0:
				animator.play("idle_side")
				animator.flip_h = false
			elif direction.y > 0:
				animator.play("idle_front")
				animator.flip_h = false
			else:
				animator.play("idle_back")
				animator.flip_h = false
		direction = new_direction
		velocity = direction * speed
	
	# old animations from corey
	#if Input.is_action_just_pressed("right"):
	#	animator.play("walk_side")
	#	animator.flip_h = true
	#if Input.is_action_just_released("right"):
	#	animator.play("idle_side")
	#if Input.is_action_just_pressed("left"):
	#	animator.play("walk_side")
	#	animator.flip_h = false
	#if Input.is_action_just_released("left"):
	#	animator.play("idle_side")
	#if Input.is_action_just_pressed("up"):
	#	animator.play("walk_back")
	#if Input.is_action_just_released("up"):
	#	animator.play("idle_back")
	#if Input.is_action_just_pressed("down"):
	#	animator.play("walk_front")
	#if Input.is_action_just_released("down"):
	#	animator.play("idle_front")
	
	move_and_slide()
