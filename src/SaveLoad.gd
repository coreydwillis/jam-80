extends Node

const save_location = "user://RabbitSave10.json"

var contents_to_save: Dictionary = {
	"runs": 1,
	"longest_run": 1,
	"master_volume": 1,
	"music_volume": 1,
	"sfx_volume": 1,
	"fullscreen": true
}

func _ready():
	_load()

func _save():
	_fillSaveData()
	var file  = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _fillSaveData():
	contents_to_save.runs = Game.runs
	if Game.days > Game.longest_run:
		contents_to_save.longest_run = Game.days
	contents_to_save.master_volume = Game.master_volume
	contents_to_save.music_volume = Game.music_volume
	contents_to_save.sfx_volume = Game.sfx_volume
	contents_to_save.fullscreen = Game.fullscreen
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.runs = save_data.runs
		contents_to_save.longest_run = save_data.longest_run
		contents_to_save.master_volume = save_data.master_volume
		contents_to_save.music_volume = save_data.music_volume
		contents_to_save.sfx_volume = save_data.sfx_volume
		contents_to_save.fullscreen = save_data.fullscreen
		_set_game_vars()

func _set_game_vars():
	Game.runs = contents_to_save.runs
	Game.longest_run = contents_to_save.longest_run
	Game.master_volume = contents_to_save.master_volume
	Game.music_volume = contents_to_save.music_volume
	Game.sfx_volume = contents_to_save.sfx_volume
	Game.fullscreen = contents_to_save.fullscreen
