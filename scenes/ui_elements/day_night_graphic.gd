extends Panel

func _ready():
	SignalBus.day_started.connect(timeFlip)
	SignalBus.night_started.connect(timeFlip)
	
func timeFlip():
	if Game.is_day:
		$Sprite2D.frame = 0
	else:
		$Sprite2D.frame = 1
		if Game.bunnies_in_pen < Game.bunnies_needed:
			SignalBus.game_over.emit()
