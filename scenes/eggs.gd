extends Label

func _ready():
	SignalBus.egg_count_change.connect(update)

func update():
	text = str(Game.eggs)
