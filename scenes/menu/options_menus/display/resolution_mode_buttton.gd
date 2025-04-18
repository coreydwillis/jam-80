extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICTIONARY : Dictionary = {
	"1920 x 1080" : Vector2i(1920,1080),
	"2560 x 1440" : Vector2i(2560,1440),
	"3840 x 2160" : Vector2i(3840,2160)
}

func _ready():
	add_resolution_items()
	load_data()

func load_data():
	_on_option_button_item_selected(SettingsDataContainer.get_resolution_mode_index())
	option_button.select(SettingsDataContainer.get_resolution_mode_index())

func add_resolution_items():
	for resolution_size_text in RESOLUTION_DICTIONARY:
		option_button.add_item(resolution_size_text)

func _on_option_button_item_selected(index):
	SignalBusSettings.emit_on_resolution_selected(index)
	DisplayServer.window_set_size(RESOLUTION_DICTIONARY.values()[index])
	
