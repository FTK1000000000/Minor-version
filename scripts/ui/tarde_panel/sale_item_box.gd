extends Button


@onready var trade_panel: Control = $"../../../.."
@onready var item_icon: TextureRect = $HBoxContainer/Icon
@onready var item_name: Label = $HBoxContainer/Name
@onready var item_price: Label = $HBoxContainer/HBoxContainer/Price

@export var item: InventoryItem


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)


func read_item(read_item: InventoryItem):
	item = read_item
	item_icon.texture = read_item.icon
	item_name.text = (read_item.name if read_item.name else read_item.data_name)
	item_price.text = str(read_item.price)


func _on_button_up() -> void:
	trade_panel.sale(item)
	queue_free()
