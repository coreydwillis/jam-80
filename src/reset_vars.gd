extends Node

func _ready():
	SignalBus.reset_game_vars.connect(reset_var_func)
	SignalBus.reset_names.emit()
	
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
	Game.hammer_enabled = false
	Game.boombox_enabled = false
	Game.magnet_enabled = false
