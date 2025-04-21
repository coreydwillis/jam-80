extends Node2D

var player_near : bool = false

func _ready():
	SignalBus.day_started.connect(_on_day_start)

func _on_day_start():
	$Label.visible = false

func _on_area_2d_body_entered(body):
	if !Game.is_day and body.name == "Player":
		$Label.visible = true
		player_near = true
		
func _process(_delta):
	if !Game.is_day and player_near:
		if Input.is_action_just_pressed("use"):
			Game.is_day = true
			Game.days += 1
			SignalBus.day_started.emit()
			$Label.visible = false

func _on_area_2d_body_exited(body):
	if !Game.is_day and body.name == "Player":
		$Label.visible = false
		player_near = false
