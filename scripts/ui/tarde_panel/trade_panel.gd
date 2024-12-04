extends Control


const SALE_ITEM_BOX = preload("res://ui/trade_panel/sale_item_box.tscn")


@onready var sale_panel: PanelContainer = $SalePanel
@onready var sale_range_list_bar: VBoxContainer = $SalePanel/VBoxContainer/SaleRangeListBar

@export var item_list: Array[InventoryItem]


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	
	sale_panel.hide()
	close()


func open():
	#Global.game_pause()
	show()

func close():
	#Global.game_keep()
	hide()
	sale_panel.hide()

func sale(item: InventoryItem):
	if item is InventoryCard:
		for slot in GlobalPlayerState.player_card_inventory.slots:
			if slot.item == item:
				slot.item = null
				#Global.HUD.card_bar.update()
				GlobalPlayerState.player_card_inventory.update.emit()
				GlobalPlayerState.money += item.price
				GlobalPlayerState.money_changed.emit()
				
				print("[trade] sale => ", item.data_name)
				return

func sale_list_spawn():
	for node in sale_range_list_bar.get_children():
		sale_range_list_bar.remove_child(node)
	
	var card: Array
	var get_card = func ():
		for slot in GlobalPlayerState.player_card_inventory.slots:
			if slot.item:
				card.push_back(slot.item)
	
	get_card.call()
	var range: Array
	range = (card)
	
	var item_amount: int = range.size()
	while sale_range_list_bar.get_children().size() < item_amount:
		var item: InventoryItem = range.pop_back()
		var item_box: Node
		
		sale_range_list_bar.add_child(SALE_ITEM_BOX.instantiate())
		item_box = sale_range_list_bar.get_children().back()
		
		item_box.read_item(item)


func _on_back_button_up() -> void:
	close()


func _on_sale_button_up() -> void:
	sale_list_spawn()
	sale_panel.show()


func _on_sale_list_close_button_up() -> void:
	sale_panel.hide()
