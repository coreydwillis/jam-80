extends Control

@onready var viewport: Viewport = get_viewport()

func _ready():
	get_tree().paused = true

func _on_resume_button_pressed():
	get_tree().paused = false
	queue_free()

func _on_main_button_pressed():
	get_tree().paused = false
	viewport.canvas_transform = Transform2D(0, Vector2(0,0))
	get_tree().change_scene_to_file("uid://bxroi0e1f7wuh")

func _on_quit_button_pressed():
	get_tree().quit()
