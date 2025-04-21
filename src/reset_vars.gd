extends Node

func _ready():
	SignalBus.reset_game_vars.connect(reset_var_func)
	
func reset_var_func():
	Game.game_over = Game.GAME_OVER_DEFAULT
	Game.danger_time = Game.DANGER_TIME_DEFAULT
	Game.days = Game.DAYS_DEFAULT
	Game.is_day = Game.IS_DAY_DEFAULT
	Game.game_started = Game.GAME_STARTED_DEFAULT
	Game.bunnies_in_pen = Game.BUNNIES_IN_PEN_DEFAULT
	Game.total_bunnies = Game.TOTAL_BUNNIES_DEFAULT
	Game.bunnies_needed = Game.BUNNIES_NEEDED_DEFAULT
	Game.bunnies_needed_inc = Game.BUNNIES_NEEDED_INC_DEFAULT
	Game.eggs = Game.EGGS_DEFAULT
