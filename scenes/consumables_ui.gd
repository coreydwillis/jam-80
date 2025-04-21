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
var selected = Consumable.EGG_DROP
@onready var player = $"/root/Main/World/Player"
var egg_painted = preload("res://scenes/game/objects/egg_pickup_painted_var.tscn")
var egg_gold = preload("res://scenes/game/objects/egg_pickup_gold.tscn")
var egg_rainbow = preload("res://scenes/game/objects/egg_pickup_rainbow.tscn")

func _ready():
	SignalBus.item_bought.connect(_on_item_bought)

func _process(_delta):
	if Input.is_action_just_pressed("consume"):
		if selected != null:
			remove_item()
			match selected:
				Consumable.CHICKEN:
					SignalBus.player_eat.emit()
					player.meat_duration = 10
				Consumable.TURKEY:
					SignalBus.player_eat.emit()
					player.meat_duration = 30
				Consumable.PIZZA:
					SignalBus.player_eat.emit()
					player.pizza_duration = 15
				Consumable.COMBO:
					SignalBus.player_eat.emit()
					player.pizza_duration = 60
				Consumable.COFFEE:
					SignalBus.player_drink.emit()
					player.coffee_duration = 10
					player.strong_coffee = false
				Consumable.ESPRESSO:
					SignalBus.player_drink.emit()
					player.coffee_duration = 20
					player.strong_coffee = true
				Consumable.EGG_DROP:
					SignalBus.player_drink.emit()
					do_eggdrop()
				Consumable.STRACIATELLA:
					SignalBus.player_eat.emit()
					do_eggdrop(true)
				Consumable.CARROT:
					SignalBus.player_eat.emit()
					player.carrot_duration = 4
				Consumable.GOLDEN_CARROT:
					SignalBus.player_eat.emit()
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

func do_eggdrop(extreme = false):
	var egg_count = 5
	if extreme: egg_count = 10
	var eggs = [egg_gold.instantiate()]
	for i in range(egg_count):
		eggs.append(egg_painted.instantiate())
	if extreme:
		eggs.append(egg_rainbow.instantiate())
	for egg in eggs:
		$"/root/Main/World/Eggs".add_child(egg)
		egg.position = Vector2((randf() * 1500) - 750, (randf() * 1500) - 750) + Game.centerpoint

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
