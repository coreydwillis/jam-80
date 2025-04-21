extends Node2D

@onready var my_timer = $Timer
var firstPass = true

func _ready():
	my_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if firstPass:
		$GodotWildJamLogo.visible = false
		$Wildcard.visible = true
		firstPass = false
