extends CanvasLayer

var firstPass = true

func _ready():
	$DayTimer.start(Game.day_length_base + (Game.days * Game.day_length_inc))
	$DayTimer.timeout.connect(_on_timer_timeout)

func _process(_delta):
	$BunniesLabel.text = "Bunnies in pen: %d\nTotal bunnies: %d \n Required bunnies: %d" % [Game.bunnies_in_pen, Game.total_bunnies, Game.bunnies_needed]
	var time_left_for_clock = $DayTimer.time_left
	if Game.is_day:
		$TimerLabel.text = "Time left in day: %d" % ceil($DayTimer.time_left)
		SignalBus.time_increment.emit(time_left_for_clock)
	else:
		$TimerLabel.text = "Time left in night: %d" % ceil($DayTimer.time_left)
		SignalBus.time_increment.emit(time_left_for_clock)

func _on_timer_timeout():
	if Game.is_day:
		Game.is_day = false
		$DayTimer.start(Game.night_length)
		SignalBus.requirement_increment.emit()
		SignalBus.night_started.emit()
	else:
		Game.days += 1
		Game.is_day = true
		$DayTimer.start(Game.day_length_base + (Game.days * Game.day_length_inc))
		SignalBus.day_started.emit()
