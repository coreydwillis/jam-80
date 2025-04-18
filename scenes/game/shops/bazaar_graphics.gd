extends Node2D

func _ready():
	SignalBus.night_started.connect(toggle_vis)
	SignalBus.day_started.connect(toggle_vis)

func toggle_vis():
	$".".visible = !$".".visible
