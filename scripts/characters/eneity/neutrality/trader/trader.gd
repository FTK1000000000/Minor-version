extends Neutral
class_name Trader


@onready var trade: Area2D = $Trade

@export var trade_item_list: Array[InventoryItem]
@export var trade_panel: Node
@export var a: Array

func _ready() -> void:
	super()
	
	roll_trade_list()
	spawn_trade_panel()


func roll_trade_list():
	var card = Global.card_data
	var item_get_range: Dictionary
	item_get_range = card
	
	while trade_item_list.size() < 3:
		var item_resource: InventoryItem
		var item: Node
		var key: String
		var keys: Array = item_get_range.keys()
		key = keys[randi() % keys.size()]
		item = load(FileFunction.get_file_list(Global.CARD_DIRECTORY).get(key)).instantiate()
		item.read()
		item_resource = item.item_resource
		trade_item_list.push_back(item_resource)
		a.push_back(item_resource)
	print("/[trader_roll_trade_list]: ", trade_item_list)

func spawn_trade_panel():
	var scene = Global.TRADE_PANEL.instantiate()
	trade_panel = scene
	trade_panel.item_list = trade_item_list
	Global.temporary_ui.add_child(trade_panel)

func melee_animaction():
	create_tween().tween_property(self, "global_position", target_position, 0.6)


func _on_melee_state_entered() -> void:
	aimline_rotation()
	
	if attack_is_ready:
		current_move_speed = 0
		target_position = attack_target.global_position
		
		animation_player.play("melee")
		await animation_player.animation_finished
		
		attack_is_ready = false
		
		if attack_timer.is_stopped():
			attack_timer.start()
			await attack_timer.timeout
			
			attack_is_ready = true
		state_chart.send_event("idle")
