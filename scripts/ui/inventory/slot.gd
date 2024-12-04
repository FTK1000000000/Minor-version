extends Button
class_name InventorySlotFromHUD


@onready var inventory = GlobalPlayerState.player_card_inventory
@onready var container = $CenterContainer
@onready var item: Sprite2D = $CenterContainer/Panel/Item


func update(inventory_slot: InventorySlot):
	if !inventory_slot.item:
		item.texture = null
		print("nullp texture")
	else:
		item.texture = inventory_slot.item.icon
