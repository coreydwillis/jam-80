extends ColorRect

func _ready():
	SignalBus.danger_time.connect(start_danger)
	SignalBus.end_danger_time.connect(end_danger)
	
func start_danger():
	visible = true

func end_danger():
	visible = false
