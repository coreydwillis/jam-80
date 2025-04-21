extends Control

@onready var longest_run = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/LongestRun

func _ready():
	await get_tree().create_timer(10).timeout
	$ColorRect.visible = true
	$MarginContainer.visible = true
	reset_vars()
	SignalBus.main_menu.emit()
	longest_run.text = "Longest Run: %d\nTotal Runs: %d" % [Game.longest_run, Game.runs]
	Game.game_started = false
	print("false")

func _on_play_button_pressed():
	get_tree().change_scene_to_file("uid://cacgvoe8aqiva")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_credits_button_pressed():
	$Credits_Menu.visible = true

func _on_options_button_pressed():
	$Options_Menu.visible = true

func reset_vars():
	Game.bunnies_needed = Game.BUNNIES_NEEDED_DEFAULT
	Game.days = 1
	Game.is_day = true
	Game.bunnies_in_pen = 0
	Game.total_bunnies = 0
