extends Resource

class_name Inventory
signal update

@export var slots : Array[InventorySlot]

func insert(item : InventoryItem):
	for slot in slots:
		if slot.item == item && slot.amount != slot.item.max_amount_stack:
			slot.amount += 1
			update.emit()
			return
	
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].amount = 1
			update.emit()
			return

func remove_slot(inventory_slot : InventorySlot):
	var index = slots.find(inventory_slot)
	if index < 0 : return
	
	slots[index] = InventorySlot.new()

func insert_slot(index : int, inventory_slot : InventorySlot):
	slots[index] = inventory_slot
