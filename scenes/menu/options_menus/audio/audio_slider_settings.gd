extends Control


@onready var audio_name_lbl = $HBoxContainer/Audio_Name_lbl as Label
@onready var audio_num_lbl = $HBoxContainer/Audio_Num_lbl as Label
@onready var h_slider = $HBoxContainer/HSlider as HSlider
@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index : int = 0

func _ready():
	set_name_label_text()
	get_bus_name_by_index()
	load_data()
	_audio_audio_num_label()
	set_slider_value()
	
func load_data() -> void:
	match bus_name:
		"Master":
			_on_h_slider_value_changed(SettingsDataContainer.get_master_volume())
		"Music":
			_on_h_slider_value_changed(SettingsDataContainer.get_music_volume())
		"SFX":
			_on_h_slider_value_changed(SettingsDataContainer.get_sfx_volume())

func set_name_label_text() -> void:
	audio_name_lbl.text = str(bus_name) + " Volume"

func _audio_audio_num_label() -> void:
	audio_num_lbl.text = str(h_slider.value * 100) + "%"

func get_bus_name_by_index() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider_value() -> void:
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	_audio_audio_num_label()

	match bus_index:
		0:
			SignalBusSettings.emit_on_master_sound_set(value)
		1:
			SignalBusSettings.emit_on_music_sound_set(value)
		2:
			SignalBusSettings.emit_on_sfx_sound_set(value)
