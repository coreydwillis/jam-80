extends Node

const SETTINGS_SAVE_PATH : String = "user://SettingsData.save"

var settings_data_dict : Dictionary = {}

func _ready():
	SignalBusSettings.set_settings_dictionary.connect(on_settings_save)
	on_load_settings_data()
	
func on_settings_save(data: Dictionary) -> void:
	var save_settings_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH, FileAccess.WRITE, "HappyEasterEveryone")

	var json_data_string = JSON.stringify(data)
	
	save_settings_data_file.store_line(json_data_string)

func on_load_settings_data() -> void:
	if not FileAccess.file_exists(SETTINGS_SAVE_PATH):
		return
	else:
		pass

	var save_settings_data_file = FileAccess.open_encrypted_with_pass(SETTINGS_SAVE_PATH, FileAccess.READ,"HappyEasterEveryone")
	var loaded_data : Dictionary = {}
	
	while save_settings_data_file.get_position() < save_settings_data_file.get_length():
		var json_string = save_settings_data_file.get_line()
		var json = JSON.new()
		var _past_result = json.parse(json_string)
		
		loaded_data = json.get_data()
	
	SignalBusSettings.emit_load_settings_data(loaded_data)
	loaded_data = {}
