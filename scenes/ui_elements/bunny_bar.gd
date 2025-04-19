extends ProgressBar

@onready var goal_bar = $GoalBar

func _ready():
	init_bunny_count()
	SignalBus.bunny_count_change.connect(bunny_count_change)
	SignalBus.night_started.connect(night_bar_changes)
	SignalBus.day_started.connect(day_bunny_count)
	
func init_bunny_count():
	max_value = Game.total_bunnies
	value = Game.total_bunnies
	goal_bar.value = Game.bunnies_needed
	goal_bar.max_value = Game.total_bunnies

func day_bunny_count():
	max_value = Game.total_bunnies
	value = Game.total_bunnies
	goal_bar.value = Game.bunnies_needed
	goal_bar.max_value = Game.total_bunnies

func bunny_count_change():
	max_value = Game.total_bunnies
	value = Game.bunnies_in_pen
	goal_bar.value = Game.bunnies_needed
	goal_bar.max_value = Game.total_bunnies

func night_bar_changes():
	pass
