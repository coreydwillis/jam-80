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
	Consumable.CARROT: 10,
	Consumable.GOLDEN_CARROT: 10
}
var tints = {
	Consumable.CHICKEN: Color(1,1,1),
	Consumable.TURKEY: Color(0.5,0.5,0.5),
	Consumable.PIZZA: Color(1,1,1),
	Consumable.COMBO: Color(0.5,0.5,0.5),
	Consumable.COFFEE: Color(1,1,1),
	Consumable.ESPRESSO: Color(0.5,0.5,0.5),
	Consumable.EGG_DROP: Color(1,1,1),
	Consumable.STRACIATELLA: Color(0.5,0.5,0.5),
	Consumable.CARROT: Color(1,1,1),
	Consumable.GOLDEN_CARROT: Color(0.5,0.5,0.5)
}
@onready var images = {
	Consumable.CHICKEN: $Turkeyleg,
	Consumable.TURKEY: $Turkeyleg,
	Consumable.PIZZA: $Pizza,
	Consumable.COMBO: $Pizza,
	Consumable.COFFEE: $Coffee,
	Consumable.ESPRESSO: $Coffee,
	Consumable.EGG_DROP: $Soup,
	Consumable.STRACIATELLA: $Soup,
	Consumable.CARROT: $Carrot,
	Consumable.GOLDEN_CARROT: $Carrot
}
var types_owned = 2
var selected = Consumable.GOLDEN_CARROT
@onready var player = $"/root/Main/World/Player"

func _ready():
	SignalBus.item_bought.connect(_on_item_bought)

func _process(_delta):
	if Input.is_action_just_pressed("consume"):
		if selected != null:
			remove_item()
			match selected:
				Consumable.CHICKEN:
					player.meat_duration = 10
				Consumable.TURKEY:
					player.meat_duration = 30
				Consumable.PIZZA:
					player.pizza_duration = 15
				Consumable.COMBO:
					player.pizza_duration = 60
				Consumable.COFFEE:
					player.coffee_duration = 10
					player.strong_coffee = false
				Consumable.ESPRESSO:
					player.coffee_duration = 20
					player.strong_coffee = true
				Consumable.EGG_DROP:
					pass
				Consumable.STRACIATELLA:
					pass
				Consumable.CARROT:
					player.carrot_duration = 4
				Consumable.GOLDEN_CARROT:
					player.carrot_duration = 12
	if Input.is_action_just_pressed("scroll_up"):
		if types_owned > 1:
			select_next(true)
			update_ui()
	if Input.is_action_just_pressed("scroll_down"):
		if types_owned > 1:
			select_next()
			update_ui()

func remove_item():
	var s = selected
	if inventory[selected] == 1:
		types_owned -= 1
		if types_owned == 0:
			selected = null
		else:
			select_next()
	inventory[s] -= 1
	update_ui()

func select_next(reverse = false):
	var inv_filtered = inventory.keys().filter(func(i): return inventory[i] != 0)
	var index = inv_filtered.find(selected)
	if reverse:
		selected = inv_filtered[index-1]
	else:
		if index == len(inv_filtered) - 1:
			selected = inv_filtered[0]
		else:
			selected = inv_filtered[index+1]

func _on_item_bought(n: String):
	if n in consumable_names.keys():
		add_item(consumable_names[n])

func add_item(item: Consumable):
	if inventory[item] == 0:
		types_owned += 1
	inventory[item] += 1
	if selected == null:
		selected = item
	if item == selected:
		update_ui()

func update_ui():
	for img in [$Carrot, $Coffee, $Pizza, $Soup, $Turkeyleg]:
		img.visible = false
	if selected != null:
		images[selected].visible = true
		images[selected].modulate = tints[selected]
		$ConsumeCount.text = str(inventory[selected])
	else:
		$ConsumeCount.text = "0"
