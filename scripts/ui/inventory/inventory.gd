extends Control


@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")
@onready var items_stack_class: = preload("res://ui/inventory/items_stack.tscn")
@onready var slots: Array = $InventoryBar.get_children()
@onready var bin: Button = $InventoryBar/SlotBin

var item_in_hand: ItemsStack
var locked: bool = false

var bin_is_open: bool


func _ready():
	connect_slot()
	inventory.update.connect(update)
	update()
	bin_close()


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

func bin_open():
	bin.visible = true
	bin_is_open = true

func bin_close():
	bin.visible = false
	bin_is_open = false

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
		
	else:
		slot_item.inventory_slot.amount = max_amount
		item_in_hand.inventory_slot.amount = total_amount - max_amount
	
	slot_item.update()
	if item_in_hand: item_in_hand.update()

func take_item_from_slot(slot):
	item_in_hand = slot.take_item()
	add_child(item_in_hand)
	update_item_in_hand()

func insert_item_in_slot(slot):
	var item = item_in_hand
	
	remove_child(item_in_hand)
	item_in_hand = null
	
	slot.insert(item)

func update_item_in_hand():
	if !item_in_hand : return
	item_in_hand.global_position = get_global_mouse_position() - item_in_hand.size / 2


func _input(_event):
	update_item_in_hand()
