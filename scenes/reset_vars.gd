extends Node

func _ready():
	SignalBus.reset_game_vars.connect(reset_var_func)
	
func reset_var_func():
	Game.game_over = false
	Game.danger_time = false
	Game.days = 1
	Game.is_day = true
	Game.game_started = false
	Game.bunnies_in_pen = 0
	Game.total_bunnies = 0
	Game.bunnies_needed = 2
	Game.bunnies_needed_inc = 1
	Game.night_length = 60
	Game.day_length_base = 30
	Game.day_length_inc= 30
	Game.centerpoint = Vector2(0,0)
	Game.pen_radius = 40.0
	Game.bunny_breed_rate = 2.5
