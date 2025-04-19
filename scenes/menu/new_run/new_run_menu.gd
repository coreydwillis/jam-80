extends Control

class_name NewRun

@onready var verse_text = $MarginContainer/HBoxContainer/VBoxContainer/VerseText
@export var verse_text_strings: Array[String] = []

func _ready():
	fill_verse_array()
	set_verse()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("uid://dup0vwkmki6wl")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	print("credits")

func _on_options_button_pressed():
	$Options_Menu.visible = true

func set_verse():
	verse_text.text = rand_verse()

func rand_verse():
	var rand_verse_text = verse_text_strings[random_number(verse_text_strings.size() - 1)]
	print (verse_text_strings.size)
	
	return rand_verse_text

func fill_verse_array():
	verse_text_strings = ["All lagomorph doth require more than mere carrots to sustain life and happiness. - Lapintations 14:4", "Of the green leaf thou shalt consume and thrive. - Songs of Green 5:21", "They will interest thee with spices and giles, but do not fall prey to their wiles. - 2 Foxes & Devils 3:7", "There will be a great leader in those days who will not strike the paws of its people. - Twin Tails 144:19", "In the time of Harekings, we must not falter to achieve our woes and gripes. - 3 Hareking Returns 1:1", "Behest thyself to keep from untoward behavior against their fellow hare, lest you fall into the unforgivable snare. - The Bunny & the Briar 3:14"]

func random_number(array_size):
	var random_int = randi_range(0, array_size)
	return random_int
