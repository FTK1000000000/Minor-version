extends Button


@onready var trade_panel: Control = $"../../../.."
@onready var money_icon: TextureRect = $VBoxContainer/HBoxContainer/MoneyIcon
@onready var item_icon_node: TextureRect = $Background
@onready var item_name_node: Label = $VBoxContainer/ItemName
@onready var item_description_node: Label = $VBoxContainer/ItemDescription
@onready var item_price_node: Label = $VBoxContainer/HBoxContainer/ItemPrice

@export var item: InventoryItem


func _ready() -> void:
	get_item()


func get_item():
	if !item:
		var item_list: Array = trade_panel.item_list
		item = item_list.pop_back()
		read_item_data(item)

func read_item_data(read_item: InventoryItem):
	if read_item:
		item_name_node.text = (item.name if item.name else item.data_name)
		item_description_node.text = item.description
		item_price_node.text = str(item.price)
		item_icon_node.texture = item.icon
		money_icon.show()
	else:
		item_name_node.text = ""
		item_description_node.text = ""
		item_price_node.text = ""
		item_icon_node.texture = null
		money_icon.hide()

func trade():
	var inventory: Inventory = GlobalPlayerState.player_card_inventory
	var empty_slot_number: int = 0
	for slot in inventory.slots:
		if !slot.item:
			empty_slot_number += 1
	
	if empty_slot_number > 0:
		inventory.add(item)
		print("add item")
	else:
		if item as InventoryCard:
			var path = Global.card_data.get(item.data_name)
			var item_instantiate = load(path).instantiate()
			
			item_instantiate.position = GlobalPlayerState.player.global_position
			GlobalPlayerState.player.get_parent().add_child(item_instantiate)
			print("inst")
		
		else:
			return
			print("not as card")
	
	item = null
	read_item_data(item)


func _on_button_up() -> void:
	trade()
	trade_panel.close()
