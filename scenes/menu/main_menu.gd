extends Control

func _ready():
	pass

func _on_play_button_pressed():
	get_tree().change_scene_to_file("uid://dup0vwkmki6wl")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	print("credits")

func _on_options_button_pressed():
	get_tree().change_scene_to_file("uid://wm20d5epi3ac")
