class_name OptionsMenu
extends Control

@onready var back_button = $MarginContainer/Seperator/Back_Button

func _ready():
	pass

func _on_back_button_pressed():
	self.visible = false
