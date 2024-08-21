extends Control

signal opened
signal closeed

@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")
@onready var items_stack_class = preload("res://inventory/items_stack.tscn")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

var is_open : bool = false

func _ready():
	slot_connect()
	inventory.update.connect(update)
	update()


func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventory_slot : InventorySlot = inventory.slot[i]
		
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
	opened.emit()

func close():
	visible = false
	is_open = false
	closeed.emit()

func slot_connect():
	for slot in slots:
		var callable = Callable(slot_click)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func slot_click(slot):
	pass
