extends Panel

@onready var item_display = $CenterContainer/Panel/item_display
@onready var amount_text = $CenterContainer/Panel/Label

@export var item: InvItem

func _ready():
	amount_text.text = ""

func update(slot: InvSlot):
	if slot.item:
		item_display.visible = true
		item_display.texture = slot.item.texture
		if slot.amount > 1:
			amount_text.visible = true
			amount_text.text = str(slot.amount)
	else:
		item_display.visible = false
		amount_text.visible = false
