extends Area2D

@export var lifetime = 1.0
@export var scale_start = 0.1
@export var scale_end = 1.0
@export var opacity_start = 0.5
@export var opacity_end = 0.1
@export var knockback_start = 120
@export var knockback_end = 60
@export var stun_start = 3.0
@export var stun_end = 1.0

var bunnies_hit = []
var timer = 0.0

func multiply(factor):
	knockback_start *= factor
	knockback_end *= factor
	stun_start *= factor
	stun_end *= factor

func _on_entered(body: Node2D):
	if body.name.begins_with("Bunny") and body not in bunnies_hit:
		bunnies_hit.append(body)
		body.switch_state(Bunny.BunnyState.STUNNED)
		body.direction = -position.direction_to(body.position)
		body.state_obj.knockback_strength = lerp(knockback_start, knockback_end, timer / lifetime)
		body.state_obj.stun_duration = lerp(stun_start, stun_end, timer / lifetime)
		body.state_obj.knockback_decay = body.state_obj.knockback_strength * body.state_obj.stun_duration
		
func _process(delta):
	timer += delta
	if timer >= lifetime:
		queue_free()
	$Sprite2D.modulate = Color(1,1,1, lerp(opacity_start, opacity_end, timer / lifetime))
	var s = lerp(scale_start, scale_end, timer / lifetime)
	scale = Vector2(s, s)
