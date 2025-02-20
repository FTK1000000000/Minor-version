extends Area2D
class_name Collectible


@onready var icon: Sprite2D = $Icon

@export var data_name: String
@export var item_resource: InventoryItem


#func collect(inventory: Inventory):
	#var item_number = 0
	#for i in inventory.slots:
		#if i.item:
			#item_number += 1
	#if item_number == inventory.slots.size(): return
	#
	#inventory.add(item_resource)
	#queue_free()

func collect(inventory: Array):
	if inventory.size() >= GlobalPlayerState.player_max_head_card_amount: return
	
	inventory.push_front(item_resource)
	Global.deck.update.emit()
	
	queue_free()
