extends Node2D

func _ready():
	pass

func _on_start_button_pressed():
	get_tree().change_scene_to_file("uid://dup0vwkmki6wl")

func _on_quit_button_pressed():
	get_tree().quit()
