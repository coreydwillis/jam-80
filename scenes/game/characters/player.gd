extends CharacterBody2D
@export var speed = 100
var dash_speed_mul_default = 2.5
var dash_duration_default = 0.5
var dash_cooldown_default = 7
var boombox_cooldown_default = 15
var hammer_cooldown_default = 10
var magnet_cooldown_default = 15
var hammer_efficacy_default = 20

var dash_speed_mul = dash_speed_mul_default
var dash_duration = dash_duration_default
var dash_cooldown = dash_cooldown_default
var boombox_cooldown = boombox_cooldown_default
var hammer_cooldown = hammer_cooldown_default
var magnet_cooldown = magnet_cooldown_default
var hammer_efficacy = hammer_efficacy_default
var magnet_multiplier = 1
var boombox_multiplier = 1

var boombox_projectile = preload("res://scenes/game/projectiles/BoomboxProjectile.tscn")
var time_since_boombox = boombox_cooldown
var time_since_dash = dash_cooldown
var time_since_hammer = hammer_cooldown
var time_since_magnet = magnet_cooldown

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
	SignalBus.player_drink.connect(drink_sound)
	SignalBus.player_eat.connect(eat_sound)

func _process(delta):
	time_since_boombox += delta
	time_since_dash += delta
	time_since_magnet += delta
	time_since_hammer += delta
	if pizza_duration > 0:
		time_since_boombox += delta
		time_since_dash += delta
		time_since_magnet += delta
		time_since_hammer += delta
	
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
		var projectile = boombox_projectile.instantiate()
		add_child(projectile)
		projectile.multiply(boombox_multiplier)
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
		$RayCast2D.rotation = position.angle_to(Game.centerpoint)
		$RayCast2D.force_raycast_update()
		if $RayCast2D.is_colliding():
			var collider = $RayCast2D.get_collider()
			if collider.name.begins_with("Fence"):
				collider.repair(hammer_efficacy)
				time_since_hammer = 0
				player_audio.set_stream(FENCE_REPAIR)
				player_audio.play()
				hammer_reset = true
				SignalBus.hammer_not_ready.emit()
	
	if dashing:
		if coffee_duration > 0:
			if strong_coffee:
				velocity = direction * speed * dash_speed_mul * 1.5
			else:
				velocity = direction * speed * dash_speed_mul * 1.25
		else:
			velocity = direction * speed * dash_speed_mul
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
			if dash_level == 2:
				dash_speed_mul = 3
				dash_duration = 0.6
				dash_cooldown = 6
			elif dash_level == 3:
				dash_speed_mul = 3.5
				dash_duration = 0.7
				dash_cooldown = 5
		"Hammer":
			hammer_level += 1
			if hammer_level == 1:
				SignalBus.hammer_purchased.emit()
			elif hammer_level == 2:
				hammer_efficacy = 40
			elif hammer_level == 3:
				hammer_efficacy = 60
		"Magnet":
			magnet_level += 1
			if magnet_level == 1:
				SignalBus.magnet_purchased.emit()
			elif magnet_level == 2:
				magnet_multiplier = 1.5
				magnet_cooldown = 12
			elif magnet_level == 3:
				magnet_multiplier = 2
				magnet_cooldown = 10
		"Boombox":
			boombox_level += 1

			if boombox_level == 1:
				SignalBus.boombox_purchased.emit()
			elif boombox_level == 2:
				boombox_multiplier = 1.5
				boombox_cooldown = 12
			elif boombox_level == 3:
				boombox_multiplier = 2
				boombox_cooldown = 10

func eat_sound():
	$Eat.play()
	
func drink_sound():
	$Drink.play()
