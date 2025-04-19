extends Node

const save_location = "user://RabbitSave.json"

var contents_to_save: Dictionary = {
	"runs": 1,
	"longest_run": 1,
}

func _ready():
	_load()
	SignalBus.game_over.connect(_save)

func _save():
	_fillSaveData()
	var file  = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	_load()
	
func _fillSaveData():
	contents_to_save.runs = Game.runs + 1
	if Game.days > Game.longest_run:
		contents_to_save.longest_run = Game.days
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.runs = save_data.runs
		contents_to_save.longest_run = save_data.longest_run
		_set_game_vars()

func _set_game_vars():
	Game.runs = contents_to_save.runs
	Game.longest_run = contents_to_save.longest_run
