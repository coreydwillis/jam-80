extends Control

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var vendor = Game.Vendor.BUNNYGIRL
var is_open = false
const PATH = "res://scenes/resources/stores/items/"
var all_items: Array[InvItem] = [
	preload(PATH+"add_bunny.tres"), preload(PATH+"add_golden.tres"), preload(PATH+"boombox.tres"),
	preload(PATH+"cape.tres"), preload(PATH+"carrot.tres"), preload(PATH+"chicken_leg.tres"),
	preload(PATH+"coffee.tres"), preload(PATH+"egg_drop.tres"), preload(PATH+"espresso.tres"),
	preload(PATH+"fence.tres"), preload(PATH+"golden_carrot.tres"), preload(PATH+"hammer.tres"),
	preload(PATH+"lasso.tres"), preload(PATH+"magnet.tres"), preload(PATH+"mutate_up.tres"),
	preload(PATH+"pizza.tres"), preload(PATH+"remove_buff.tres"), preload(PATH+"remove_gunner.tres"),
	preload(PATH+"remove_hyper.tres"), preload(PATH+"remove_killer.tres"), preload(PATH+"remove_magic.tres"),
	preload(PATH+"straciatella.tres"), preload(PATH+"turkey_leg.tres")
]
var shops = {
	Game.Vendor.RENGUY: Shop.new(Game.Vendor.RENGUY, all_items, self),
	Game.Vendor.ALIEN: Shop.new(Game.Vendor.ALIEN, all_items, self),
	Game.Vendor.BUNNYGIRL: Shop.new(Game.Vendor.BUNNYGIRL, all_items, self)
}
var shop = shops[vendor]
@onready var fluffle = $"/root/Main/World/Bunnies"

class Shop:
	var inv: Inv
	var vendor: Game.Vendor
	var vendor_name: String
	var flavor_text: String = ""
	var stock: Array[InvItem]
	var invui
	
	func _init(v: Game.Vendor, items: Array[InvItem], iu):
		invui = iu
		vendor = v
		inv = Inv.new()
		match v:
			Game.Vendor.BUNNYGIRL:
				vendor_name = Game.bunnylady_name
			Game.Vendor.RENGUY:
				vendor_name = Game.renguy_name
			Game.Vendor.ALIEN:
				vendor_name = Game.alien_name
		for item in items:
			if item.vendor == v:
				stock.append(item)
	
	func bunnytype_exists(type: Bunny.BunnyType):
		var bunnies = invui.fluffle.get_children()
		for bunny in bunnies:
			if bunny.type == type:
				return true
		return false
	
	func create_inv():
		var valid_stock = stock
		for item in valid_stock:
			if item.min_night > Game.days or item.max_owned == 0:
				valid_stock.erase(item)
			if vendor == Game.Vendor.BUNNYGIRL:
				match item.name:
					"Remove Buff Bunny":
						if not bunnytype_exists(Bunny.BunnyType.BUFF):
							valid_stock.erase(item)
					"Remove Gunner Bunny":
						if not bunnytype_exists(Bunny.BunnyType.GUNNER):
							valid_stock.erase(item)
					"Remove Magic Bunny":
						if not bunnytype_exists(Bunny.BunnyType.MAGIC):
							valid_stock.erase(item)
					"Remove Hyper Bunny":
						if not bunnytype_exists(Bunny.BunnyType.HYPER):
							valid_stock.erase(item)
					"Remove Killer Bunny":
						if not bunnytype_exists(Bunny.BunnyType.KILLER):
							valid_stock.erase(item)
		if len(valid_stock) > 4:
			var weights = valid_stock.map(func(i): return 1.0/i.rarity)
			for i in range(4):
				var index = Game.rng.rand_weighted(weights)
				weights[index] = 0
				var max_mod = valid_stock[index].max_owned
				if max_mod < 0: max_mod = 99
				inv.insert(valid_stock[index], min(max_mod, 5))
		else:
			for item in valid_stock:
				var max_mod = item.max_owned
				if max_mod < 0: max_mod = 99
				inv.insert(item, min(max_mod, 5))
	
	func update_message():
		var ids = {Game.Vendor.BUNNYGIRL: "bunnylady", Game.Vendor.ALIEN: "alien", Game.Vendor.RENGUY: "renguy"}
		var options = Game.dialog_db.filter(
			func(d): return d["dayNum"] <= Game.days and d["min_run"] <= Game.runs and d["character"] == ids[vendor]
		)
		var rarities = Game.get_column(options, "rarity").map(func(i): return 1.0/i)
		var text = Game.get_column(options, "dialog")
		flavor_text = text[Game.rng.rand_weighted(rarities)].format(Game.names_dict)
	
	func attempt_buy(slot: InvSlot):
		if Game.eggs < slot.item.price: return
		Game.eggs -= slot.item.price
		slot.amount -= 1
		slot.item.max_owned -= 1
		slot.item.price = floor(slot.item.price * slot.item.price_scaling)
		invui.update_slots()
		SignalBus.egg_count_change.emit()
		SignalBus.item_bought.emit(slot.item.name)

func switch_shop(v: Game.Vendor):
	vendor = v
	shop = shops[v]
	shop.create_inv()
	update_slots()
	$"NinePatchRect/Control/VBoxContainer/ColorRect/Flavor Text".text = shop.flavor_text
	$"NinePatchRect/Control/VBoxContainer/Name".text = shop.vendor_name
	
	match vendor:
		Game.Vendor.ALIEN:
			$NinePatchRect/AlienArt.visible = true
			$NinePatchRect/RenGuyArt.visible = false
			$NinePatchRect/BunnyArt.visible = false
		Game.Vendor.BUNNYGIRL:
			$NinePatchRect/AlienArt.visible = false
			$NinePatchRect/RenGuyArt.visible = false
			$NinePatchRect/BunnyArt.visible = true
		Game.Vendor.RENGUY:
			$NinePatchRect/AlienArt.visible = false
			$NinePatchRect/RenGuyArt.visible = true
			$NinePatchRect/BunnyArt.visible = false

func _ready():
	SignalBus.night_started.connect(start_night)
	SignalBus.day_started.connect(finish_night)
	update_slots()
	close()

func update_slots():
	for i in range(min(shop.inv.slots.size(), slots.size())):
		slots[i].update(shop.inv.slots[i])

func open(v):
	switch_shop(v)
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false

func start_night():
	for s in shops.values():
		s.update_message()

func finish_night():
	if is_open:
		close()

func _on_close_button_pressed():
	close()
