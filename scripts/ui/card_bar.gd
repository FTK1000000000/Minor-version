extends Control


const CARD_SLOT = preload("res://ui/card/card_slot.tscn")
const IS_SELECT_CARD_SLOT = preload("res://shader/material/is_select_card_slot.tres")


@onready var player_head_card: Array = Global.deck.head_pile
@onready var slots: Control = $Slots
@onready var show_position: Vector2 = slots.position

@onready var card_description: VBoxContainer = $CardDescription
@onready var card_description_name: Label = $CardDescription/Name
@onready var card_description_description: Label = $CardDescription/Description
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_selected_card_slot_index: int = 0
@export var is_selected_card: Card
var is_selected_size = Vector2(12, 12)
var not_selected_size = Vector2(8, 8)
var is_show: bool = false


func _ready():
	Global.deck.max_head_card_amount = GlobalPlayerState.player_max_head_card_amount
	Global.deck.update.connect(update.bind(false))
	card_description.hide()
	hide_animation()
	update()

func _process(_delta: float) -> void:
	update_card_bar_state()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("down"):
		var a: InventoryCard = InventoryCard.new()
		a.data_name = "test_1"
		a.name = "test_1"
		a.description = "test_1"
		a.price = 1
		a.icon = preload("res://texture/card/test.png")
		Global.deck.draw_pile = [a,a]
		print(Global.deck.draw_pile)
		Global.deck.draw_amount()
	
	if event.is_action_released("selected_card_slot"):
		if !is_show:
			is_show = true
			style_change()
		else:
			is_show = false
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


func remove_card():
	if is_selected_card:
		remove_child(is_selected_card)
		is_selected_card = null

func style_change(animation: bool = true):
	var base_position: int = ProjectSettings.get_setting("display/window/size/viewport_width") / 2
	var base_pos_tra: int = 16
	var base_rot_tra: int = 3
	var middle: int = player_head_card.size() / 2 as int
	
	for slot: InventorySlotFromHUD in slots.get_children():
		var number = slots.get_children().find(slot)
		var force = number - middle if number != middle else 0
		var rotation_value = force * base_rot_tra
		var position_value = Vector2(
			base_position + (force - 1) * slot.size.x,
			(1 if force == 0 else (force if force > 0 else force - force * 2)) * base_pos_tra
		)
		if animation:
			create_tween().tween_property(slot, "rotation_degrees", rotation_value, 0.3)
			create_tween().tween_property(slot, "position", position_value, 0.3)
		else:
			slot.rotation_degrees = rotation_value
			slot.position = position_value

func update(animation: bool = true):
	for slot: Node in slots.get_children():
		#slot.queue_free()
		slot.free()
	for item: InventoryItem in player_head_card:
		var slot_ins = CARD_SLOT.instantiate()
		slots.add_child(slot_ins)
		slot_ins.update(item)
	style_change(animation)

func show_animation():
	create_tween().tween_property(slots, "position", show_position, 0.5)

func hide_animation():
	create_tween().tween_property(slots, "position:y", show_position.y + 128, 0.5)

func update_card_bar_state():
	if slots.get_children().is_empty(): return
	
	var slot = slots.get_children()[is_selected_card_slot_index]
	if !player_head_card.is_empty():
		if Input.is_action_pressed("selected_card_slot"):
			for i in slots.get_children():
				i.item_texture.scale = not_selected_size
				i.item_texture.material = null
			slot.item_texture.scale = is_selected_size
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
					show_animation()
		
		elif !Input.is_action_pressed("selected_card_slot") || !Input.is_action_pressed("play_is_selected_card"):
			slot.item_texture.scale = not_selected_size
			slot.item_texture.material = null
			
			remove_card()
			hide_animation()
		
		if is_selected_card:
			is_selected_card.global_position = get_global_mouse_position()
			
			var item = is_selected_card.item_resource
			card_description_name.text = item.name if item.name else item.data_name
			card_description_description.text = item.description if item.description else item.data_name
			card_description.show()
			
			if Input.is_action_just_pressed("play_is_selected_card"):
				is_selected_card.play()
				slots.get_children()[is_selected_card_slot_index].animation_player.play("disappear")
				player_head_card.remove_at(is_selected_card_slot_index)
				update(false)
				
				hide_animation()
		else:
			card_description.hide()
