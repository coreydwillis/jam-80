extends Node2D

@export var vendor: Game.Vendor
@onready var player = $/root/Main/World/Player
@onready var inv_ui = $/root/Main/PauseMenuCanvas/InvUi

func _process(_delta):
	if position.distance_to(player.position) < 80:
		$OpenStoreText.visible = true
	else:
		$OpenStoreText.visible = false
	if Input.is_action_just_pressed("use") and position.distance_to(player.position) < 80:
		if inv_ui.is_open:
			inv_ui.close()
		else:
			inv_ui.open(vendor)
