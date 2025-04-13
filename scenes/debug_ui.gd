extends Node

@onready var day_timer = $DayTimer

var firstPass = true

func _ready():
	$RunLabel.text = "Longest Run: %d" % Game.longest_run
	day_timer.timeout.connect(_on_timer_timeout)
	setDaysLabel()

func _process(_delta):
	$BunniesLabel.text = "Bunnies in pen: %d\nTotal bunnies: %d" % [Game.bunnies_in_pen, Game.total_bunnies]

func _on_timer_timeout():
	Game.days += 1
	setDaysLabel()

func setDaysLabel():
	$DaysLabel.text = "Day: %d" % Game.days
