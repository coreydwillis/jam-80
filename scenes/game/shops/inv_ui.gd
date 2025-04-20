extends Control

@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
var vendor = Game.Vendor.BUNNYGIRL
var is_open = false
var shops = {
	Game.Vendor.RENGUY: Shop.new(Game.Vendor.RENGUY),
	Game.Vendor.ALIEN: Shop.new(Game.Vendor.ALIEN),
	Game.Vendor.BUNNYGIRL: Shop.new(Game.Vendor.BUNNYGIRL)
}
var shop = shops[vendor]

class Shop:
	var inv = preload("uid://c105vaje7d5hb")
	var vendor: Game.Vendor
	var vendor_name: String
	var flavor_text: String
	
	func _init(v: Game.Vendor):
		vendor = v
		match v:
			Game.Vendor.BUNNYGIRL:
				vendor_name = "Bunnygirl"
				flavor_text = "I know a lot about bunnies... I'm just a big fan."
			Game.Vendor.RENGUY:
				vendor_name = "Renguy"
				flavor_text = "The faire is pretty quiet today. I have some stuff to sell though."
			Game.Vendor.ALIEN:
				vendor_name = "Alien"
				flavor_text = "This isn't a spaceship, it's a... model plane. Work in progress."

func switch_shop(v: Game.Vendor):
	vendor = v
	shop = shops[v]
	update_slots()
	$"NinePatchRect/Control/VBoxContainer/ColorRect/Flavor Text".text = shop.flavor_text
	$"NinePatchRect/Control/VBoxContainer/Name".text = shop.vendor_name

func _ready():
	shop.inv.update.connect(update_slots)
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

func finish_night():
	if is_open:
		close()
