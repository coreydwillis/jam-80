extends Node2D

@onready var my_timer = $Timer
var firstPass = true

func _ready():
	my_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	print("help")
	if firstPass:
		$GodotWildJamLogo.visible = false
		$Wildcard.visible = true
		firstPass = false
	else:
		$Wildcard.visible = false
		get_tree().change_scene_to_file("uid://cnppfpokdqeob")
