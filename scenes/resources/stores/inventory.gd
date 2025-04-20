class_name Inv

var slots: Array[InvSlot] = [InvSlot.new(), InvSlot.new(), InvSlot.new(), InvSlot.new()]

func insert(item: InvItem, amount: int = 1):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
