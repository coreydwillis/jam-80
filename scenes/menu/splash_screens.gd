extends Node2D

@onready var my_timer = $Timer
var firstPass = true
var isSecond = false
func _ready():
	my_timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if firstPass:
		$GodotWildJamLogo.visible = false
		$Wildcard.visible = true
		firstPass = false
		isSecond = true
	if isSecond:
		await get_tree().create_timer(5).timeout
		SignalBus.splash_done.emit()
		my_timer.stop()
