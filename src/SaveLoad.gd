extends Node

const save_location = "user://RabbitSave10.json"

var contents_to_save: Dictionary = {
	"runs": 1,
	"longest_run": 1,
	"mainVolume": 1,
	"musicVolume": 1,
	"sfxVolume": 1,
	"fullScreen": true
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
	contents_to_save.mainVolume = Game.mainVol
	contents_to_save.musicVolume = Game.musicVol
	contents_to_save.sfxVolume = Game.sfxVol
	contents_to_save.fullScreen = Game.fullScreen
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.runs = save_data.runs
		contents_to_save.longest_run = save_data.longest_run
		contents_to_save.mainVolume = save_data.mainVolume
		contents_to_save.musicVolume = save_data.musicVolume
		contents_to_save.sfxVolume = save_data.sfxVolume
		contents_to_save.fullScreen = save_data.fullScreen
		_set_game_vars()

func _set_game_vars():
	Game.runs = contents_to_save.runs
	Game.longest_run = contents_to_save.longest_run
	Game.mainVol = contents_to_save.mainVolume
	Game.musicVol = contents_to_save.musicVolume
	Game.sfxVol = contents_to_save.sfxVolume
	Game.fullScreen = contents_to_save.fullScreen
