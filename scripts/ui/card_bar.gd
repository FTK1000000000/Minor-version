extends Control


const CARD_SLOT = preload("res://ui/card/card_slot.tscn")
const IS_SELECT_CARD_SLOT = preload("res://shader/material/is_select_card_slot.tres")


@onready var deck: Deck = Global.deck
@onready var player_head_card: Array = Global.deck.head_pile
@onready var slots: Control = $Slots
@onready var show_position: Vector2 = slots.position

@onready var card_description: VBoxContainer = $Background/CardDescription
@onready var card_description_name: Label = $Background/CardDescription/Name
@onready var card_description_description: Label = $Background/CardDescription/Description

@export var is_selected_card_slot_index: int = 0
@export var is_selected_card: Card
var hide_range: int = 160
var is_selected_size = Vector2(12, 12)
var not_selected_size = Vector2(8, 8)
var is_show: bool = false
var is_playing: bool = false
var is_updeteing: bool = false


func _ready():
	Global.deck.max_head_card_amount = GlobalPlayerState.max_head_card_amount
	Global.deck.update.connect(update.bind(false))
	card_description.hide()
	hide_animation()
	update()

func _process(_delta: float) -> void:
	update_card_bar_state()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		var a: InventoryCard = InventoryCard.new()
		a.data_name = "test_1"
		a.name = "test_1"
		a.description = "test_1"
		a.price = 1
		a.icon = preload("res://texture/card/test.png")
		Global.deck.draw_pile = [a,a]
		Global.deck.draw_amount()
	
	if event.is_action_released("selected_card_slot"):
		if !is_show:
			is_show = true
			show_animation()
			style_change()
		else:
			is_show = false
			hide_animation()
	
	if is_show:
		var max_amount = player_head_card.size() - 1
		if event.is_action_pressed("card_slot_index+"):
			if is_selected_card_slot_index >= max_amount:
				is_selected_card_slot_index = 0
			else:
				is_selected_card_slot_index += 1
			
			remove_card()
		elif event.is_action_pressed("card_slot_index-"):
			if is_selected_card_slot_index <= 0:
				is_selected_card_slot_index = max_amount
			else:
				is_selected_card_slot_index -= 1
			
			remove_card()
		
		if event.is_action_released("play_is_selected_card") && !is_playing && !is_updeteing:
			is_playing = true
			match is_selected_card.item_resource.type:
				"deck":
					is_selected_card.play()
					deck.discard(player_head_card[is_selected_card_slot_index])
					var ui_slot: InventorySlotFromHUD = slots.get_children()[is_selected_card_slot_index]
					ui_slot.playing = true
					ui_slot.play()
					await ui_slot.tree_exited
					
					update(true, true)
				
				"expendable":
					is_selected_card.play()
					player_head_card.remove_at(is_selected_card_slot_index)
					var ui_slot: InventorySlotFromHUD = slots.get_children()[is_selected_card_slot_index]
					ui_slot.playing = true
					ui_slot.play()
					await ui_slot.tree_exited
					
					update(true, true)
				
				"ability":
					Global.erro_tip("you do not can play ability card")
				
			get_viewport().set_input_as_handled()
			is_playing = false


func remove_card():
	if is_selected_card:
		remove_child(is_selected_card)
		is_selected_card = null

func style_change(animation: bool = true, play_card_index: int = -1):
	var base_position: int = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
	var base_pos_tra: int = 16
	var base_rot_tra: int = 3
	var middle: int = player_head_card.size() / 2 as int
	var is_play: bool = play_card_index != -1
	
	if is_play:
		var slot_ins = CARD_SLOT.instantiate()
		slots.add_child(slot_ins)
		slots.move_child(slot_ins, play_card_index)
	
	for slot: InventorySlotFromHUD in slots.get_children():
		var number = slots.get_children().find(slot)
		var force = number - middle if number != middle else 0
		var old_rotation_value: int = force * base_rot_tra
		var old_position_value: Vector2 = Vector2(
			base_position + (force - 1) * slot.size.x,
			(1 if force == 0 else (force if force > 0 else force - force * 2)) * base_pos_tra
		)
		slot.rotation_degrees = old_rotation_value
		slot.position = old_position_value
	
	if is_play:
		slots.get_child(play_card_index).queue_free()
		await get_tree().process_frame
		
		for slot: InventorySlotFromHUD in slots.get_children():
			var number = slots.get_children().find(slot)
			var force = number - middle if number != middle else 0
			var new_rotation_value: int = force * base_rot_tra
			var new_position_value: Vector2 = Vector2(
				base_position + (force - 1) * slot.size.x,
				(1 if force == 0 else (force if force > 0 else force - force * 2)) * base_pos_tra
			)
			if animation:
				create_tween().tween_property(slot, "rotation_degrees", new_rotation_value, 0.3)
				create_tween().tween_property(slot, "position", new_position_value, 0.3)
			else:
				slot.rotation_degrees = new_rotation_value
				slot.position = new_position_value

func update(animation: bool = true, is_play: bool = false):
	is_updeteing = true
	for slot: InventorySlotFromHUD in slots.get_children():
		slot.queue_free()
		#slot.free()
	await get_tree().process_frame
	
	for item: InventoryItem in player_head_card:
		var slot_ins = CARD_SLOT.instantiate()
		slots.add_child(slot_ins)
		slot_ins.update(item)
	if is_play:
		style_change(animation, is_selected_card_slot_index)
	else:
		style_change(animation)
	is_updeteing = false

func show_animation():
	create_tween().tween_property(slots, "position", show_position, 0.5)

func hide_animation():
	if is_selected_card != null:
		remove_card()
	
	create_tween().tween_property(slots, "position:y", show_position.y + hide_range, 0.5)

func update_card_bar_state():
	if is_selected_card_slot_index >= slots.get_children().size() && is_selected_card_slot_index != 0:
		is_selected_card_slot_index -= 1
	
	if !player_head_card.is_empty() && is_show:
		var slot: InventorySlotFromHUD = slots.get_children()[is_selected_card_slot_index]
		for i in slots.get_children():
			i.item_texture.scale = not_selected_size
			if i.item_texture.material == IS_SELECT_CARD_SLOT:
				i.item_texture.material = null
		slot.item_texture.scale = is_selected_size
		if !slot.playing:
			slot.item_texture.material = IS_SELECT_CARD_SLOT
		
		if !(player_head_card.size() - 1) < is_selected_card_slot_index:
			var item: InventoryCard = player_head_card[is_selected_card_slot_index]
			if !is_selected_card && item:
				var card_data_name = item.data_name
				var card_instantiate = load(FileFunction.get_file_list(Global.CARD_DIRECTORY).get(card_data_name)).instantiate()
				is_selected_card = card_instantiate
				
				add_child(is_selected_card)
				is_selected_card.monitorable = false
				is_selected_card.scale = Vector2(3, 3)
				is_selected_card.icon.material.set_shader_parameter("highlight", false)
		
		if is_selected_card != null:
			is_selected_card.global_position = get_global_mouse_position()
			
			var item = is_selected_card.item_resource
			card_description_name.text = item.name if item.name else item.data_name
			card_description_description.text = item.description if item.description else item.data_name
			card_description.show()
		else:
			card_description.hide()
	elif is_show:
		is_show = false
		hide_animation()
