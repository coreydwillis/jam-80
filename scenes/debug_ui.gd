extends CanvasLayer

var firstPass = true

func _ready():
	$RunLabel.text = "Longest Run: %d" % Game.longest_run
	$DayTimer.start(Game.day_length_base + (Game.days * Game.day_length_inc))
	$DayTimer.timeout.connect(_on_timer_timeout)
	setDaysLabel()

func _process(_delta):
	$BunniesLabel.text = "Bunnies in pen: %d\nTotal bunnies: %d" % [Game.bunnies_in_pen, Game.total_bunnies]
	if Game.is_day:
		$TimerLabel.text = "Time left in day: %d" % ceil($DayTimer.time_left)
	else:
		$TimerLabel.text = "Time left in night: %d" % ceil($DayTimer.time_left)

func _on_timer_timeout():
	if Game.is_day:
		Game.is_day = false
		$DayTimer.start(Game.night_length)
		SignalBus.night_started.emit()
	else:
		Game.days += 1
		Game.is_day = true
		$DayTimer.start(Game.day_length_base + (Game.days * Game.day_length_inc))
		setDaysLabel()
		SignalBus.day_started.emit()

func setDaysLabel():
	$DaysLabel.text = "Day: %d" % Game.days
