extends Button
class_name InventorySlotFromHUD


@onready var inventory = Global.deck.head_pile

@onready var container = $CenterContainer
@onready var item_texture: Sprite2D = $CenterContainer/Panel/Item


func update(inventory_item: InventoryItem):
	if !inventory_item:
		item_texture.texture = null
	else:
		item_texture.texture = inventory_item.icon
