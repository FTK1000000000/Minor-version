extends Control


@onready var player_head_car = Global.deck
@onready var player_head_card: Array = Global.deck.head_pile
@onready var slots: Array = $HBoxContainer.get_children()

@onready var card_description: VBoxContainer = $CardDescription
@onready var card_description_name: Label = $CardDescription/Name
@onready var card_description_description: Label = $CardDescription/Description
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var is_selected_card_slot_index: int = 0
@export var is_selected_card: Card


func _ready():
	Global.deck.update.connect(update)
	update()
	
	#card_description.text = ""
	card_description.hide()

func _process(_delta: float) -> void:
	update_card_bar_state()

func _unhandled_input(event: InputEvent) -> void:
	var max_amount = player_head_card.size() - 1
	
	if event.is_action_pressed("card_slot_index+"):
		if is_selected_card_slot_index == max_amount:
			is_selected_card_slot_index = 0
		else:
			is_selected_card_slot_index += 1
		
		remove_card()
	elif event.is_action_pressed("card_slot_index-"):
		if is_selected_card_slot_index == 0:
			is_selected_card_slot_index = max_amount
		else:
			is_selected_card_slot_index -= 1
		
		remove_card()


func update():
	for i in range(player_head_card.size()):
		var item: InventoryItem = player_head_card[i]
		if !item: continue
		
		var slot = slots[i]
		slot.update(item)

func remove_card():
	if is_selected_card:
		remove_child(is_selected_card)
		is_selected_card = null

func update_card_bar_state():
	var slot = slots[is_selected_card_slot_index]
	var is_selected_size = Vector2(5, 5)
	var not_selected_size = Vector2(3, 3)
	
	if !player_head_card.is_empty():
		if Input.is_action_pressed("selected_card_slot"):
			for i in slots:
				i.item_texture.scale = not_selected_size
			slot.item_texture.scale = is_selected_size
			
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
		
		elif !Input.is_action_pressed("play_is_selected_card") || !Input.is_action_pressed("play_is_selected_card"):
			slot.item_texture.scale = not_selected_size
			
			remove_card()
		
		if is_selected_card:
			is_selected_card.global_position = get_global_mouse_position()
			
			var item = is_selected_card.item_resource
			card_description_name.text = item.name if item.name else item.data_name
			card_description_description.text = item.description if item.description else item.data_name
			card_description.show()
			
			if Input.is_action_pressed("play_is_selected_card"):
				is_selected_card.play()
				is_selected_card = null
				player_head_card.remove_at(is_selected_card_slot_index)
				
				var ui_slot = slots[is_selected_card_slot_index]
				if !(player_head_card.size() - 1) < is_selected_card_slot_index:
					ui_slot.update(player_head_card[is_selected_card_slot_index])
				else:
					ui_slot.update(null)
		else:
			#card_description.text = ""
			card_description.hide()

#func show_animation():
	#var number: int = 0
	#while !number > slots:
		#number += 1
	#for slot in slots:
		#create_tween().tween_property()
