extends Node2D



func _ready():
	SignalBus.cycle_consume.connect(consume_cycled)

func consume_cycled():
	print("cycle consumable")
