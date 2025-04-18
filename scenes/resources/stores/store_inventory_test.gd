extends Node

@export var inv: Inv
@export var item_to_collect: InvItem
const TURKEY_LEG = preload("res://scenes/resources/stores/items/turkey_leg.tres")

func _ready():
	collect(TURKEY_LEG)
	collect(TURKEY_LEG)
	collect(TURKEY_LEG)

func collect(item):
	inv.insert(item)
