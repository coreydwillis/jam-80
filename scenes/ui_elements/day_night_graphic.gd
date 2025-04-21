extends Panel

func _ready():
	SignalBus.day_started.connect(timeFlip)
	SignalBus.night_started.connect(timeFlip)
	
func timeFlip():
	if Game.is_day:
		$Sun.visible = true
		$Moon.visible = false
	else:
		$Sun.visible = false
		$Moon.visible = true
		if Game.bunnies_in_pen < Game.bunnies_needed:
			SignalBus.game_over.emit()
