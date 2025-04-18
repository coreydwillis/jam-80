class_name CreditsMenu
extends Control

@onready var back_button = $MarginContainer/Seperator/Back_Button

@onready var settings_tab_container = $MarginContainer/Seperator/SettingsTabContainer as SettingsTabContainer

signal exit_options_menu

func _ready():
	pass

func _on_back_button_pressed():
	exit_options_menu.emit()
	SignalBusSettings.emit_set_settings_dictionary(SettingsDataContainer.create_storage_dictionary())
	self.visible = false
