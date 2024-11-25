extends Area2D


@export var item_resource: InventoryItem


func collect(inventory: Inventory):
	var item_number = 0
	for i in inventory.slots:
		if i.item:
			item_number += 1
	if item_number == inventory.slots.size(): return
	
	inventory.add(item_resource)
	queue_free()
