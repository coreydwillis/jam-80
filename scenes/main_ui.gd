extends Timer

var firstPass = true

func _ready():
	start(Game.day_length_base + (Game.days * Game.day_length_inc))
	timeout.connect(_on_timer_timeout)
	SignalBus.night_started.connect(start_night)
	SignalBus.day_started.connect(start_day)

func _process(_delta):
	if Game.is_day or (Game.night_timer and !Game.is_day):
		SignalBus.time_increment.emit(time_left)

func _on_timer_timeout():
	if Game.is_day:
		Game.is_day = false
		SignalBus.night_started.emit()
	else:
		Game.is_day = true
		SignalBus.day_started.emit()

func start_night():
	Game.is_day = false
	if Game.night_timer:
		start(Game.night_length)
	else:
		stop()
	
func start_day():
	Game.is_day = true
	Game.days += 1
	start(Game.day_length_base + (Game.days * Game.day_length_inc))
