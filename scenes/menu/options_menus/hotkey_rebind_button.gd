class_name HotKeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = "left"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	load_keybinds()

func load_keybinds() -> void:
	rebind_action_key(SettingsDataContainer.get_keybinds(action_name))

func set_action_name() -> void:
	label.text = "Unassigned"

	match action_name:
		"up":
			label.text = "Move Up"
		"down":
			label.text = "Move Down"
		"left":
			label.text = "Move Left"
		"right":
			label.text = "Move Right"
		"use":
			label.text = "Interact"
		"ability1":
			label.text = "Use Ability 1"
		"ability2":
			label.text = "Use Ability 2"
		"ability3":
			label.text = "Use Ability 3"
		"ability4":
			label.text = "Use Ability 4"
		"consume":
			label.text = "Consumable"
		"jump":
			label.text = "Dash"

func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	button.text = "%s" % action_keycode

func _on_button_toggled(toggled_on):
	if toggled_on:
		button.text = "Press any key..."
		set_process_unhandled_key_input(toggled_on)
		
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
			
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
				
		set_text_for_key()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false
	
func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	SettingsDataContainer.set_keybinds(action_name, event)

	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
