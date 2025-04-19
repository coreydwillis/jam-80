extends Panel

var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var msec: int = 0

func _ready():
	SignalBus.time_increment.connect(increment_time)

func increment_time(time_left_for_clock):
	time = time_left_for_clock
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	$minutes_label.text = "%02d:" % minutes
	$seconds_label.text = "%02d" % seconds
