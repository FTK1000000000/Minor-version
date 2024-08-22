extends Control

signal opened
signal closeed

@onready var inventory : Inventory = preload("res://inventory/player_inventory.tres")
@onready var slots : Array = $NinePatchRect/GridContainer.get_children()

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])

func _ready():
	inventory.update.connect(update)
	update()

var is_open : bool = false

func open():
	visible = true
	is_open = true
	opened.emit()


func close():
	visible = false
	is_open = false
	closeed.emit()
