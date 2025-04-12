extends Node

const save_location = "user://RabbitSave2.json"

var contents_to_save: Dictionary = {
	"runs": 1,
	"longest_run": 1
}

func _ready():
	_load()

func _save():
	var file  = FileAccess.open(save_location, FileAccess.WRITE)
	contents_to_save.longest_run = Game.days
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.runs = save_data.runs
		contents_to_save.longest_run = save_data.longest_run
		_set_vars()

func _set_vars():
	Game.runs = contents_to_save.runs
	Game.longest_run = contents_to_save.longest_run
