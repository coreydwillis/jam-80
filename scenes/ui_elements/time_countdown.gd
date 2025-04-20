extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0
@onready var minutes_label = $minutes_label
@onready var seconds_label = $seconds_label
@onready var infinite_time = $infinite_time

func _ready():
	SignalBus.night_started.connect(check_night_timer)
	SignalBus.day_started.connect(set_time_vis)
	SignalBus.time_increment.connect(increment_time)

func increment_time(time_left_for_clock):
	time = time_left_for_clock
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	seconds_label.text = "%02d:" % minutes
	seconds_label.text = "%02d" % seconds
	if time <= 30 and (Game.bunnies_needed > Game.bunnies_in_pen) and !Game.danger_time:
		SignalBus.danger_time.emit()
		Game.danger_time = true
	if time <= 30 and (Game.bunnies_needed <= Game.bunnies_in_pen) and Game.danger_time:
		SignalBus.end_danger_time.emit()
		Game.danger_time = false

func check_night_timer():
	if Game.night_timer:
		infinite_time.visible = true
		minutes_label.visible = false
		seconds_label.visible = false
		
func set_time_vis():
		infinite_time.visible = false
		minutes_label.visible = true
		seconds_label.visible = true
