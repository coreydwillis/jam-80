extends Node2D

@onready var settings_menu = $CenterContainer/SettingsMenu
@onready var credits_menu = $CenterContainer/CreditsMenu
@onready var main_buttons = $CenterContainer/MainButtons

func _ready():
	$CenterContainer/SettingsMenu/fullscreen.button_pressed = true if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else false
	setFullScreen()
	#setVolume should be moved into another script for general start up/setup stuff
	setVolume()
	setVolumeSliders()
	#$CenterContainer/SettingsMenu/sfxVolSlider3.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))

func setVolume():
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), Game.mainVol)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), Game.musicVol)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), Game.sfxVol)

func setVolumeSliders():
	$CenterContainer/SettingsMenu/mainVolSlider.value = Game.mainVol
	$CenterContainer/SettingsMenu/musicVolSlider.value = Game.musicVol
	$CenterContainer/SettingsMenu/sfxVolSlider.value = Game.sfxVol

func setFullScreen():
	$CenterContainer/SettingsMenu/fullscreen.toggle_mode = Game.fullScreen

func _on_start_button_pressed():
	get_tree().change_scene_to_file("uid://dup0vwkmki6wl")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_credits_pressed():
	main_buttons.visible = false
	credits_menu.visible = true

func _on_back_pressed():
	main_buttons.visible = true
	credits_menu.visible = false
	settings_menu.visible = false

# This will all move to an independant Settings menu later
func _on_settings_pressed():
	main_buttons.visible = false
	settings_menu.visible = true

func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		Game.fullScreen = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		Game.fullScreen = false
		
	SaveLoad._save()

func _on_main_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), value)
	Game.mainVol = value
	SaveLoad._save()

func _on_music_vol_slider_value_changed(value):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), value)
	Game.musicVol = value
	SaveLoad._save()

func _on_sfx_vol_slider_3_value_changed(value):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), value)
	Game.sfxVol = value
	SaveLoad._save()
