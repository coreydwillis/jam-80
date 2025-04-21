extends CharacterBody2D
@export var speed = 100
@export var dash_speed = 300
@export var dash_duration = 0.7
@export var dash_cooldown = 5
@export var boombox_cooldown = 10
@export var hammer_cooldown = 10
@export var magnet_cooldown = 10
@export var lasso_cooldown = 10

var boombox_projectile = preload("res://scenes/game/projectiles/BoomboxProjectile.tscn")
var time_since_boombox = boombox_cooldown
var time_since_dash = dash_cooldown
var time_since_hammer = hammer_cooldown
var time_since_magnet = magnet_cooldown
var time_since_lasso = lasso_cooldown

@onready var animator = $AnimatedSprite2D

# Audio
@onready var player_audio = $PlayerAudio
const PLAYER_HIT = preload("res://assets/audio/sfx/player/Player Hit.wav")
const PLAYER_PICKUP = preload("res://assets/audio/sfx/player/pickup.wav")
const PLAYER_ZAP = preload("res://assets/audio/sfx/abilities/Electricity Zap.wav")
const PLAYER_DASH = preload("res://assets/audio/sfx/abilities/vanilla whoosh.wav")
const BOOM_BOX = preload("res://assets/audio/sfx/abilities/JoJo_s Bizarre Boombox (Base).wav")
const DRINK = preload("res://assets/audio/sfx/abilities/drink.wav")
const FENCE_REPAIR = preload("res://assets/audio/sfx/abilities/Fence Repair.wav")
const PLAYER_MAGNET = preload("res://assets/audio/sfx/abilities/magnet.wav")
const PLAYER_LASSO = preload("res://assets/audio/sfx/abilities/whip.wav")

var dashing = false
var direction: Vector2
var stun_duration = 0

var dash_reset: bool = true
var magnet_reset: bool = true
var hammer_reset: bool = true
var boombox_reset: bool = true

var strong_coffee = false
var carrot_duration = 0
var coffee_duration = 0
var meat_duration = 0
var pizza_duration = 0

var dash_level = 1
var boombox_level = 0
var magnet_level = 0
var hammer_level = 0

func _ready():
	SignalBus.item_bought.connect(_on_item_bought)

func _process(delta):
	time_since_boombox += delta
	time_since_dash += delta
	time_since_magnet += delta
	time_since_hammer += delta
	time_since_lasso += delta
	if pizza_duration > 0:
		time_since_boombox += delta
		time_since_dash += delta
		time_since_magnet += delta
		time_since_hammer += delta
		time_since_lasso += delta
	
	carrot_duration -= delta
	coffee_duration -= delta
	meat_duration -= delta
	pizza_duration -= delta
	
		
	if time_since_boombox >= boombox_cooldown and boombox_reset:
		SignalBus.boombox_ready.emit()
		boombox_reset = false
	
	if time_since_dash >= dash_cooldown and dash_reset:
		SignalBus.dash_ready.emit()
		dash_reset = false
		
	if time_since_magnet >= magnet_cooldown and magnet_reset:
		SignalBus.magnet_ready.emit()
		magnet_reset = false
		
	if time_since_hammer >= hammer_cooldown and hammer_reset:
		SignalBus.hammer_ready.emit()
		hammer_reset = false
		
	#if time_since_lasso >= lasso_cooldown and dash_reset:
		#SignalBus.lasso_ready.emit()
	
	if meat_duration > 0:
		stun_duration = 0
	
	if stun_duration > 0:
		## Enable this somewhere to play a zip sound when stunned
		#player_audio.set_stream(PLAYER_ZAP)
		#player_audio.play()
		stun_duration -= delta
		return
		
	if velocity.length() > 0 and $Timer.time_left <= 0:
		$PlayFootsteps.play()
		$Timer.start(0.8)
		
	# Dash
	if Input.is_action_just_pressed("jump") and time_since_dash >= dash_cooldown:
		dashing = true
		time_since_dash = 0
		player_audio.set_stream(PLAYER_DASH)
		player_audio.play()
		dash_reset = true
		SignalBus.dash_not_ready.emit()
		
	# Boombox
	if Input.is_action_just_pressed("ability1") and Game.boombox_enabled and time_since_boombox >= boombox_cooldown:
		add_child(boombox_projectile.instantiate())
		time_since_boombox = 0
		player_audio.set_stream(BOOM_BOX)
		player_audio.play()
		boombox_reset = true
		SignalBus.boombox_not_ready.emit()
		
	# Magnet
	if Input.is_action_just_pressed("ability2") and Game.magnet_enabled and time_since_magnet >= magnet_cooldown:
		time_since_magnet = 0
		player_audio.set_stream(PLAYER_MAGNET)
		player_audio.play()
		magnet_reset = true
		SignalBus.magnet_not_ready.emit()
	
	# Hammer
	if Input.is_action_just_pressed("ability3") and Game.hammer_enabled and time_since_hammer >= hammer_cooldown:
		time_since_hammer = 0
		player_audio.set_stream(FENCE_REPAIR)
		player_audio.play()
		hammer_reset = true
		SignalBus.hammer_not_ready.emit()
		
	# Lasso
	#if Input.is_action_just_pressed("ability4") and time_since_lasso >= lasso_cooldown:
		#time_since_lasso = 0
		#player_audio.set_stream(PLAYER_LASSO)
		#player_audio.play()
		#SignalBus.lasso_not_ready.emit()
	
	if dashing:
		if coffee_duration > 0:
			if strong_coffee:
				velocity = direction * dash_speed * 1.5
			else:
				velocity = direction * dash_speed * 1.25
		else:
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
		if coffee_duration > 0:
			if strong_coffee:
				velocity = direction * speed * 1.5
			else:
				velocity = direction * speed * 1.25
		else:
			velocity = direction * speed
	
	move_and_slide()

func _on_item_bought(n: String):
	match n:
		"Cape":
			dash_level += 1
		"Hammer":
			if hammer_level == 0:
				SignalBus.hammer_purchased.emit()
			hammer_level += 1
		"Magnet":
			if magnet_level == 0:
				SignalBus.magnet_purchased.emit()
			magnet_level += 1
		"Boombox":
			if boombox_level == 0:
				SignalBus.boombox_purchased.emit()
			boombox_level += 1
