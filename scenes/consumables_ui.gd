extends Node2D

enum Consumable {
	CHICKEN,
	TURKEY,
	PIZZA,
	COMBO,
	COFFEE,
	ESPRESSO,
	EGG_DROP,
	STRACIATELLA,
	CARROT,
	GOLDEN_CARROT
}

var consumable_names = {
	"Chicken Leg": Consumable.CHICKEN,
	"Turkey Leg": Consumable.TURKEY,
	"Pizza": Consumable.PIZZA,
	"Combo Pizza": Consumable.COMBO,
	"Cup of Coffee": Consumable.COFFEE,
	"Triple Shot Espresso": Consumable.ESPRESSO,
	"Egg Drop Soup": Consumable.EGG_DROP,
	"Straciatella alla Romana": Consumable.STRACIATELLA,
	"Carrot": Consumable.CARROT,
	"Golden Carrot": Consumable.GOLDEN_CARROT
}

var inventory = {
	Consumable.CHICKEN: 0,
	Consumable.TURKEY: 0,
	Consumable.PIZZA: 0,
	Consumable.COMBO: 0,
	Consumable.COFFEE: 0,
	Consumable.ESPRESSO: 0,
	Consumable.EGG_DROP: 0,
	Consumable.STRACIATELLA: 0,
	Consumable.CARROT: 0,
	Consumable.GOLDEN_CARROT: 0
}
var types_owned = 0

func _ready():
	SignalBus.cycle_consume.connect(consume_cycled)
	SignalBus.item_bought.connect(_on_item_bought)

func consume_cycled():
	print("cycle consumable")

func _on_item_bought(n: String):
	if n in consumable_names.keys():
		add_item(consumable_names[n])

func add_item(item: Consumable):
	if inventory[item] == 0:
		types_owned += 1
	inventory[item] += 1
	print("consumable added!")
