extends Panel

@onready var item_display = $CenterContainer/Panel/item_display


func update(item: InvItem):
	if item:
		item_display.visible = true
		item_display.texture = item.texture
	else:
		item_display.visible = false
