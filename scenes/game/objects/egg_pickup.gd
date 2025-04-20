extends Node2D

class_name EggPickup

@onready var egg_graphic = $EggGraphic


@export var egg_type : String
@export var egg_value : int
@export var egg_type_graphic : CompressedTexture2D

func _ready():
	egg_graphic.texture = egg_type_graphic

func _on_area_2d_body_entered(_body):
	Game.eggs += egg_value
	SignalBus.egg_count_change.emit()
	queue_free()
