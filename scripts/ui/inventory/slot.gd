extends Button
class_name InventorySlotFromHUD


@onready var inventory = Global.deck.head_pile

@onready var container = $CenterContainer
@onready var item: Sprite2D = $CenterContainer/Panel/Item


func update(inventory_slot: InventorySlot):
	if !inventory_slot.item:
		item.texture = null
	else:
		item.texture = inventory_slot.item.icon
