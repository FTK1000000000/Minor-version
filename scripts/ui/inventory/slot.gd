extends Button

@onready var background_sprite : Sprite2D = $Background
@onready var container = $CenterContainer
@onready var inventory = preload("res://inventory/player_inventory.tres")

var items_stack : ItemsStack
var index : int

func insert(isg : ItemsStack):
	items_stack = isg
	background_sprite.frame = 1
	container.add_child(items_stack)
	
	if !items_stack.inventory_slot || inventory.slots[index] == items_stack.inventory_slot:
		return
	
	inventory.insert_slot(index, items_stack.inventory_slot)

func take_item():
	var item = items_stack
	
	inventory.remove_slot(items_stack.inventory_slot)
	
	container.remove_child(items_stack)
	items_stack = null
	background_sprite.frame = 0
	
	return item

func is_empty():
	return !items_stack
