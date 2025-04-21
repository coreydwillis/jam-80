extends Control

@onready var longest_run = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/LongestRun
var splash_screen_menu = load("uid://dkq4uxka87wmh")
var splash_screen_menu_instance

func _ready():
	visible = true
	$ColorRect.visible = true
	$MarginContainer.visible = true
	if !Game.splash_done:
		SignalBus.splash_done.connect(initial_setup)
		splash_screen_menu_instance = splash_screen_menu.instantiate()
		add_child(splash_screen_menu_instance)
	if Game.splash_done:
		SignalBus.main_menu.emit()
	SignalBus.reset_names.emit()
	
func initial_setup():
	$ColorRect.visible = true
	$MarginContainer.visible = true
	reset_vars()
	SignalBus.main_menu.emit()
	longest_run.text = "Longest Run: %d\nTotal Runs: %d" % [Game.longest_run, Game.runs]
	Game.game_started = false
	if !Game.splash_done:
		splash_screen_menu_instance.visible = false
		Game.splash_done = true
		SignalBus.main_menu.emit()

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
