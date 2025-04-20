extends Control

@onready var state_label = $HBoxContainer/State_Label as Label
@onready var check_button = $HBoxContainer/CheckButton as CheckButton

func _ready():
	load_data()

func load_data():
	_on_check_button_toggled(SettingsDataContainer.night_time_timer)

func set_label_text(toggled_on: bool):
	if toggled_on:
		state_label.text = "On"
		check_button.button_pressed = true
	else:
		state_label.text = "Off"
		check_button.button_pressed = false

func _on_check_button_toggled(toggled_on):
	set_label_text(toggled_on)
	SignalBusSettings.emit_on_night_time_toggled(toggled_on)
	Game.night_timer = !Game.night_timer
