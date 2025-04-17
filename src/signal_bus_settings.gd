extends Node

# Settings Signals #
## Graphics Signals ##
signal on_window_mode_selected(index : int)
signal on_resolution_selected(index : int)

## Sound Signals ##
signal on_master_sound_set(value : float)
signal on_music_sound_set(value : float)
signal on_sfx_sound_set(value : float)

## Accessibility Signals ##
signal night_timer_toggled(value: bool)

## Create Settings Dictionary ##
signal set_settings_dictionary(settings_dict : Dictionary)

## Create Settings Load Dictionary ##
signal load_settings_data(settings_dict : Dictionary)

# Signal Functions #
## Graphics Functions ##
func emit_on_window_mode_selected(index : int) -> void:
	on_window_mode_selected.emit(index)

func emit_on_resolution_selected(index : int) -> void:
	on_resolution_selected.emit(index)

## Sound Functions ##
func emit_on_master_sound_set(value : float) -> void:
	on_master_sound_set.emit(value)
	
func emit_on_music_sound_set(value : float) -> void:
	on_music_sound_set.emit(value)
	
func emit_on_sfx_sound_set(value : float) -> void:
	on_sfx_sound_set.emit(value)

## Accessibility Functions ##
func emit_on_night_time_toggled(value : bool) -> void:
	night_timer_toggled.emit(value)

## Dictionary Functions ##
func emit_set_settings_dictionary(settings_dict : Dictionary) -> void:
	set_settings_dictionary.emit(settings_dict)

func emit_load_settings_data(settings_dict : Dictionary) -> void:
	load_settings_data.emit(settings_dict)
