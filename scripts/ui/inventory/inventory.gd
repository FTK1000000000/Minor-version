extends Control

#signal opened
#signal closeed


@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")
@onready var items_stack_class : = preload("res://ui/inventory/items_stack.tscn")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

var is_open : bool = false

var item_in_hand : ItemsStack
#var old_index : int = -1
var locked : bool = false


func _ready():
	connect_slot()
	inventory.update.connect(update)
	update()


func connect_slot():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = 1
		
		var callable = Callable(slot_click)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventory_slot : InventorySlot = inventory.slots[i]
		
		if !inventory_slot.item : continue
		
		var items_stack : ItemsStack = slots[i].items_stack
		if !items_stack:
			items_stack = items_stack_class.instantiate()
			slots[i].insert(items_stack)
		
		items_stack.inventory_slot = inventory_slot
		items_stack.update()

func open():
	visible = true
	is_open = true
	#opened.emit()

func close():
	visible = false
	is_open = false
	#closeed.emit()

func slot_click(slot):
	if locked: return
	
	if slot.is_empty():
		if !item_in_hand: return
		
		insert_item_in_slot(slot)
		return
	
	if !item_in_hand:
		take_item_from_slot(slot)
		return
	
	if slot.items_stack.inventory_slot.item.name == item_in_hand.inventory_slot.item.name:
		stack_item(slot)
		return
	item_swap(slot)

func item_swap(slot):
	var temp_item = slot.take_item()
	
	insert_item_in_slot(slot)
	
	item_in_hand = temp_item
	add_child(item_in_hand)
	update_item_in_hand()

func stack_item(slot):
	var slot_item : ItemsStack = slot.items_stack
	var max_amount = slot_item.inventory_slot.item.max_amount_stack
	var total_amount = slot_item.inventory_slot.amount + item_in_hand.inventory_slot.amount
	
	if slot_item.inventory_slot.amount == max_amount:
		item_swap(slot)
		return
	
	if total_amount <= max_amount:
		slot_item.inventory_slot.amount = total_amount
		remove_child(item_in_hand)
		item_in_hand = null
		
		#old_index = -1
	else:
		slot_item.inventory_slot.amount = max_amount
		item_in_hand.inventory_slot.amount = total_amount - max_amount
	
	slot_item.update()
	if item_in_hand: item_in_hand.update()

func take_item_from_slot(slot):
	item_in_hand = slot.take_item()
	add_child(item_in_hand)
	update_item_in_hand()
	
	#old_index = slot.index

func insert_item_in_slot(slot):
	var item = item_in_hand
	
	remove_child(item_in_hand)
	item_in_hand = null
	
	slot.insert(item)
	
	#old_index = -1

func update_item_in_hand():
	if !item_in_hand : return
	item_in_hand.global_position = get_global_mouse_position() - item_in_hand.size / 2

#func put_item_back():
	#locked = true
	#if old_index < 1:
		#var empty_slots = slots.filter(func (s): return s.is_empty())
		#if empty_slots.is_empty(): return
		#
		#old_index = empty_slots[0].index
	#
	#var target_slot = slots[old_index]
	#var tween = create_tween()
	#var target_position = target_slot.global_position + target_slot.size / 2
	#tween.tween_property(item_in_hand, "global_position", target_position, 0.2)
	#await tween.finished
	#
	#insert_item_in_slot(target_slot)
	#locked = false

func _input(_event):
	#if item_in_hand && !locked && Input.is_action_just_pressed("right_click"):
		#put_item_back()
	update_item_in_hand()
