extends Control


@onready var player_card_inventory: Inventory = GlobalPlayerState.player_card_inventory
@onready var slots: Array = $HBoxContainer.get_children()


func _ready():
	player_card_inventory.update.connect(update)
	update()


func update():
	for i in range(min(player_card_inventory.slots.size(), slots.size())):
		var inventory_slot: InventorySlot = player_card_inventory.slots[i]
		if !inventory_slot.item: continue
		
		var slot = slots[i]
		slot.inventory_slot = inventory_slot
		slot.update(inventory_slot)
		print(slot.name)
