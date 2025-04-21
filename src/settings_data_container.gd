extends Node

@onready var DEFAULT_SETTINGS : DefaultSettingsResource = preload("res://scenes/resources/settings_folder/DefaultSettings.tres")
@onready var keybind_resource : PlayerKeybindResource = preload("res://scenes/resources/settings_folder/PlayerKeybindDefault.tres")

# Settings Vars #
var window_mode_index : int = 0
var resolution_index : int = 0
var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var night_time_timer: bool = false

var loaded_data : Dictionary = {}

func _ready():
	handle_signals()
	
	
func create_storage_dictionary() -> Dictionary:
	var settings_container_dict : Dictionary = {
		"window_mode_index" : window_mode_index,
		"resolution_index" : resolution_index,
		"master_volume" : master_volume,
		"music_volume" : music_volume,
		"sfx_volume" : sfx_volume,
		"night_time_timer" : night_time_timer,
		"keybinds" : create_keybind_dict()
	}
	
	return settings_container_dict

func create_keybind_dict() -> Dictionary:
	var keybind_container_dict = {
		keybind_resource.MOVE_LEFT : keybind_resource.move_left_key,
		keybind_resource.MOVE_RIGHT : keybind_resource.move_right_key,
		keybind_resource.MOVE_UP : keybind_resource.move_up_key,
		keybind_resource.MOVE_DOWN : keybind_resource.move_down_key,
		keybind_resource.JUMP : keybind_resource.jump_key,
		keybind_resource.ABILITY1 : keybind_resource.ability1_key,
		keybind_resource.ABILITY2 : keybind_resource.ability2_key,
		keybind_resource.ABILITY3 : keybind_resource.ability3_key,
		keybind_resource.ABILITY4 : keybind_resource.ability4_key,
		keybind_resource.CONSUME : keybind_resource.consume_key,
		keybind_resource.CONSUME_CYCLE : keybind_resource.consume_cycle_key,
		keybind_resource.USE : keybind_resource.use_key
	}
	return keybind_container_dict
	

func get_window_mode_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_WINDOW_MODE_INDEX
	return window_mode_index

func get_resolution_mode_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_RESOLUTION_INDEX
	return resolution_index

func get_master_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_MASTER_VOLUME
	return master_volume
	
func get_music_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_MUSIC_VOLUME
	return music_volume
	
func get_sfx_volume() -> float:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_SFX_VOLUME
	return sfx_volume

func get_night_timer() -> bool:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_NIGHT_TIMER
	return night_time_timer

func get_keybinds(action : String):
	if !loaded_data.has("keybinds"):
		match action:
			keybind_resource.MOVE_LEFT:
				return keybind_resource.DEFAULT_MOVE_LEFT_KEY
			keybind_resource.MOVE_RIGHT:
				return keybind_resource.DEFAULT_MOVE_RIGHT_KEY
			keybind_resource.MOVE_UP:
				return keybind_resource.DEFAULT_UP_KEY
			keybind_resource.MOVE_DOWN:
				return keybind_resource.DEFAULT_DOWN_KEY
			keybind_resource.JUMP:
				return keybind_resource.DEFAULT_JUMP_KEY
			keybind_resource.ABILITY1:
				return keybind_resource.DEFAULT_ABILITY1_KEY
			keybind_resource.ABILITY2:
				return keybind_resource.DEFAULT_ABILITY2_KEY
			keybind_resource.ABILITY3:
				return keybind_resource.DEFAULT_ABILITY3_KEY
			keybind_resource.ABILITY4:
				return keybind_resource.DEFAULT_ABILITY4_KEY
			keybind_resource.CONSUME:
				return keybind_resource.DEFAULT_CONSUME_KEY
			keybind_resource.CONSUME_CYCLE:
				return keybind_resource.DEFAULT_CONSUME_CYCLE_KEY
			keybind_resource.USE:
				return keybind_resource.DEFAULT_USE_KEY
	else:
		match action:
			keybind_resource.MOVE_LEFT:
				return keybind_resource.move_left_key
			keybind_resource.MOVE_RIGHT:
				return keybind_resource.move_right_key
			keybind_resource.MOVE_UP:
				return keybind_resource.move_up_key
			keybind_resource.MOVE_DOWN:
				return keybind_resource.move_down_key
			keybind_resource.JUMP:
				return keybind_resource.jump_key
			keybind_resource.ABILITY1:
				return keybind_resource.ability1_key
			keybind_resource.ABILITY2:
				return keybind_resource.ability2_key
			keybind_resource.ABILITY3:
				return keybind_resource.ability3_key
			keybind_resource.ABILITY4:
				return keybind_resource.ability4_key
			keybind_resource.CONSUME:
				return keybind_resource.consume_key
			keybind_resource.CONSUME_CYCLE:
				return keybind_resource.consume_cycle_key
			keybind_resource.USE:
				return keybind_resource.use_key

func on_window_mode_selected(index : int) -> void:
	window_mode_index = index
	
func on_resolution_mode_selected(index : int) -> void:
	resolution_index = index

func on_master_sound_set(value : float) -> void:
	master_volume = value
	
func on_music_sound_set(value : float) -> void:
	music_volume = value
	
func on_sfx_sound_set(value : float) -> void:
	sfx_volume = value
	
func on_night_time_timer_set(value : bool) -> void:
	night_time_timer = value
	
func set_keybinds(action: String, event) -> void:
	match action:
		keybind_resource.MOVE_LEFT:
			keybind_resource.move_left_key = event
		keybind_resource.MOVE_RIGHT:
			keybind_resource.move_right_key = event
		keybind_resource.MOVE_UP:
			keybind_resource.move_up_key = event
		keybind_resource.MOVE_DOWN:
			keybind_resource.move_down_key = event
		keybind_resource.JUMP:
			keybind_resource.jump_key = event
		keybind_resource.ABILITY1:
			keybind_resource.ability1_key = event
		keybind_resource.ABILITY2:
			keybind_resource.ability2_key = event
		keybind_resource.ABILITY3:
			keybind_resource.ability3_key = event
		keybind_resource.ABILITY4:
			keybind_resource.ability4_key = event
		keybind_resource.CONSUME:
			keybind_resource.consume_key = event
		keybind_resource.CONSUME_CYCLE:
			keybind_resource.consume_cycle_key = event
		keybind_resource.USE:
			keybind_resource.use_key = event
	
func on_keybinds_loaded(data : Dictionary) -> void:
	var loaded_move_left = InputEventKey.new()
	var loaded_move_right = InputEventKey.new()
	var loaded_move_up = InputEventKey.new()
	var loaded_move_down = InputEventKey.new()
	var loaded_jump = InputEventKey.new()
	var loaded_ability1 = InputEventKey.new()
	var loaded_ability2 = InputEventKey.new()
	var loaded_ability3 = InputEventKey.new()
	var loaded_ability4 = InputEventKey.new()
	var loaded_consume = InputEventKey.new()
	var loaded_consume_cycle = InputEventKey.new()
	var loaded_use = InputEventKey.new()
	
	loaded_move_left.set_physical_keycode(int(data.left))
	loaded_move_right.set_physical_keycode(int(data.right))
	loaded_move_up.set_physical_keycode(int(data.up))
	loaded_move_down.set_physical_keycode(int(data.down))
	loaded_jump.set_physical_keycode(int(data.jump))
	loaded_ability1.set_physical_keycode(int(data.ability1))
	loaded_ability2.set_physical_keycode(int(data.ability2))
	loaded_ability3.set_physical_keycode(int(data.ability3))
	loaded_ability4.set_physical_keycode(int(data.ability4))
	loaded_consume.set_physical_keycode(int(data.consume))
	loaded_consume_cycle.set_physical_keycode(int(data.consume_cycle))
	loaded_use.set_physical_keycode(int(data.use))
	
	keybind_resource.move_left_key = loaded_move_left
	keybind_resource.move_right_key = loaded_move_right
	keybind_resource.move_up_key = loaded_move_up
	keybind_resource.move_down_key = loaded_move_down
	keybind_resource.jump_key = loaded_jump
	keybind_resource.ability1_key = loaded_ability1
	keybind_resource.ability2_key = loaded_ability2
	keybind_resource.ability3_key = loaded_ability3
	keybind_resource.ability4_key = loaded_ability4
	keybind_resource.consume_key = loaded_consume
	keybind_resource.consume_cycle_key = loaded_consume_cycle
	keybind_resource.use_key = loaded_use
	
	
func on_settings_data_loaded(data : Dictionary) -> void:
	loaded_data = data
	on_window_mode_selected(loaded_data.window_mode_index)
	on_resolution_mode_selected(loaded_data.resolution_index)
	on_master_sound_set(loaded_data.master_volume)
	on_music_sound_set(loaded_data.music_volume)
	on_sfx_sound_set(loaded_data.sfx_volume)
	on_night_time_timer_set(loaded_data.night_time_timer)
	on_keybinds_loaded(loaded_data.keybinds)
	
	
func handle_signals() -> void:
	SignalBusSettings.on_window_mode_selected.connect(on_window_mode_selected)
	SignalBusSettings.on_resolution_selected.connect(on_resolution_mode_selected)
	SignalBusSettings.on_master_sound_set.connect(on_master_sound_set)
	SignalBusSettings.on_music_sound_set.connect(on_music_sound_set)
	SignalBusSettings.on_sfx_sound_set.connect(on_sfx_sound_set)
	SignalBusSettings.night_timer_toggled.connect(on_night_time_timer_set)
	SignalBusSettings.load_settings_data.connect(on_settings_data_loaded)
