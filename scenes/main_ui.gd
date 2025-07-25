extends Timer

var firstPass = true

func _ready():
	# Give bonus time for first day too
	var day_time_bonus = 20 if Game.days <= 2 else (10 if Game.days <= 4 else 0)
	start(Game.day_length_base + (Game.days * Game.day_length_inc) + day_time_bonus)
	timeout.connect(_on_timer_timeout)
	SignalBus.night_started.connect(start_night)
	SignalBus.day_started.connect(start_day)

func _process(_delta):
	if Game.is_day or (!Game.night_timer and !Game.is_day):
		SignalBus.time_increment.emit(time_left)

func _on_timer_timeout():
	if Game.is_day:
		if Game.bunnies_in_pen < Game.bunnies_needed:
			SignalBus.end_danger_time.emit()
			SignalBus.game_over.emit()
			Game.eggs = 0
		Game.is_day = false
		SignalBus.night_started.emit()
	else:
		Game.is_day = true
		SignalBus.day_started.emit()

func start_night():
	Game.is_day = false	
	if Game.days == 8:
		SignalBus.check_win.emit()
	if !Game.night_timer:
		start(Game.night_length)
	else:
		stop()
	
func start_day():
	Game.is_day = true
	Game.days += 1
	SignalBus.day_increment.emit()
	
	# Give more time in early days
	var day_time_bonus = 0
	if Game.days <= 2:
		day_time_bonus = 20  # Extra 20 seconds for first 2 days
	elif Game.days <= 4:
		day_time_bonus = 10  # Extra 10 seconds for days 3-4
	
	start(Game.day_length_base + (Game.days * Game.day_length_inc) + day_time_bonus)
