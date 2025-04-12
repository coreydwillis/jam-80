extends Node

@onready var day_timer = $DayTimer

var firstPass = true

func _ready():
	Game.days = 1
	$RunLabel.text = "Longest Run: %d" % Game.longest_run
	day_timer.timeout.connect(_on_timer_timeout)
	setDaysLabel()

func _on_timer_timeout():
	Game.days += 1
	setDaysLabel()

func setDaysLabel():
	$DaysLabel.text = "Day: %d" % Game.days
