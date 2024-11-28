extends Resource
class_name Inventory

signal update


@export var slots: Array[InventorySlot]


func add(item: InventoryItem):
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			update.emit()
			return

func remove(index: int):
	slots[index].item = null
