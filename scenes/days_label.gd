extends Label

func _ready():
	SignalBus.day_started.connect(setDaysLabel)
	text = str(Game.days)

func setDaysLabel():
	text = str(Game.days)
