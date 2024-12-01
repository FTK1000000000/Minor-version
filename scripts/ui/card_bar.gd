extends Control


@onready var player_card_inventory: Inventory = GlobalPlayerState.player_card_inventory
@onready var slots: Array = $HBoxContainer.get_children()
@onready var card_description: Label = $CardDescription

@export var is_selected_card_slot_index: int = 0
@export var is_selected_card: Card


func _ready():
	player_card_inventory.update.connect(update)
	update()
	
	card_description.text = ""

func _process(_delta: float) -> void:
	var slot = slots[is_selected_card_slot_index]
	var is_selected_size = Vector2(5, 5)
	var not_selected_size = Vector2(3, 3)
	
	if Input.is_action_pressed("selected_card_slot"):
		for i in slots:
			i.item.scale = not_selected_size
		slot.item.scale = is_selected_size
		
		var inventory_slot: InventorySlot = player_card_inventory.slots[is_selected_card_slot_index]
		var item: InventoryItem = inventory_slot.item
		
		if inventory_slot.item is InventoryCard && !is_selected_card:
			var card_data = inventory_slot.item.data_name
			var card_instantiate = load(Global.card_data.get(card_data)).instantiate()
			is_selected_card = card_instantiate
			
			add_child(is_selected_card)
			is_selected_card.monitorable = false
			is_selected_card.scale = Vector2(3, 3)
			is_selected_card.icon.material.set_shader_parameter("highlight", false)
	
	elif !Input.is_action_pressed("play_is_selected_card") || !Input.is_action_pressed("play_is_selected_card"):
		slot.item.scale = not_selected_size
		
		remove_card()
	
	if is_selected_card:
		is_selected_card.global_position = get_global_mouse_position()
		
		var item = is_selected_card.item_resource
		card_description.text = \
			item.description if item.description else item.data_name
		
		if Input.is_action_pressed("play_is_selected_card"):
			is_selected_card.play()
			is_selected_card = null
			
			player_card_inventory.remove(is_selected_card_slot_index)
			var ui_slot = slots[is_selected_card_slot_index]
			ui_slot.update(player_card_inventory.slots[is_selected_card_slot_index])
	else:
		card_description.text = ""

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("card_slot_index+"):
		if is_selected_card_slot_index == 2:
			is_selected_card_slot_index = 0
		else:
			is_selected_card_slot_index += 1
		
		remove_card()
	
	elif event.is_action_pressed("card_slot_index-"):
		if is_selected_card_slot_index == 0:
			is_selected_card_slot_index = 2
		else:
			is_selected_card_slot_index -= 1
		
		remove_card()


func update():
	for i in range(min(player_card_inventory.slots.size(), slots.size())):
		var inventory_slot: InventorySlot = player_card_inventory.slots[i]
		if !inventory_slot.item: continue
		
		var slot = slots[i]
		slot.update(inventory_slot)

func remove_card():
	if is_selected_card:
		remove_child(is_selected_card)
		is_selected_card = null

#func update_description():
	#if is_selected_card:
		#var inventory_slot: InventorySlot = player_card_inventory.slots[is_selected_card_slot_index]
		#var item: InventoryItem = inventory_slot.item
		#
		#card_description.text = \
			#item.description if item.description else item.data_name
