extends Panel

@onready var item_display = $CenterContainer/Panel/item_display
@onready var amount_text = $CenterContainer/Panel/Label

var slot: InvSlot = null
var hovered = false
var delay = 0

func _ready():
	amount_text.text = ""

func _process(delta):
	if delay > 0:
		delay -= delta
		if delay < 0:
			delay = 0
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered:
		$"..".shop.attempt_buy(slot)
		delay = 0.2

func update(new_slot: InvSlot):
	slot = new_slot
	if slot.item:
		item_display.visible = true
		item_display.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
			amount_text.text = str(slot.amount)
	else:
		item_display.visible = false
		amount_text.visible = false

func _on_hover():
	hovered = true
	if slot.item != null:
		$"../../ColorRect/Description".text = slot.item.description

func _on_exit():
	hovered = false
	$"../../ColorRect/Description".text = "Hover over an item to reveal a description."
