class_name Fence extends StaticBody2D

var is_broken = false
var health = 100.0
var max_health = 100.0
var level = 1

func _ready():
	SignalBus.item_bought.connect(_on_item_bought)

func damage(num):
	if is_broken: return
	health -= num
	if health <= 0:
		health = 0
		is_broken = true
	$Sprite2D.scale.y = lerp(0, 184, health / max_health)

func repair(num):
	if is_broken:
		is_broken = false
	health += num
	if health >= max_health:
		health = max_health
	$Sprite2D.scale.y = lerp(0, 184, health / max_health)

func _on_item_bought(n: String):
	if n == "Fence":
		level += 1
		health += 100
		max_health += 100
