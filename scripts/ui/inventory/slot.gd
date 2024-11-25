extends Button
class_name InventorySlotFromHUD


@onready var inventory = GlobalPlayerState.player_card_inventory
@onready var container = $CenterContainer
@onready var item: Sprite2D = $CenterContainer/Panel/Item

@export var inventory_slot: InventorySlot


func update(inventory_slot: InventorySlot):
	item.texture = inventory_slot.item.icon
