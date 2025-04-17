extends Node

signal classes_select
signal weapon_update
signal update_variable
signal health_changed
signal endurance_changed
signal money_changed
signal player_dead


var player: Player
var weapon: Weapon
var classes: String
var max_head_card_amount: int = 7
var wealth: int = 100:
	set(v):
		wealth = v
		
		#dark styem
		var vignette = Global.HUD.vignette
		var dark_level
		for i in vignette.level_intensity:
			if vignette.level_intensity.get(i).get("price") <= wealth:
				dark_level = i
		vignette.level = dark_level
var max_health: int = 100
var max_endurance: int = 100
var move_speed: int = Common.move_speed
var walk_move_speed_multiple: float = 1.0
var run_move_speed_multiple: float = 2.0
var current_move_speed_multiple: float = 1.0

var current_health: int:
	set(v):
		current_health = v
		if player:
			player.current_health = v
var current_endurance: int:
	set(v):
		current_endurance = v
		if player:
			player.current_endurance = v
var endurance_recover_amount: int = 10
var endurance_recover_ready: int = 1
var endurance_recover_speed: float = 0.2
var endurance_recover_ready_speed: float = 0.5
var knockback_power: int = 300

var effects: Array[Effect] = []
var money: int = 0
var kill: int = 0

#for tank
var weapon_attack_twice = false

#for hunter
var dodge_length: int = 1000
var dodge_endurance_consume: int = 30
var dodge_ready_time: float = 3
var dodge_time: float = 0.2
var sturdy_shield = false

#for mage
var rapid_fire = false


func _ready() -> void:
	classes_select.connect(update_classes)
	
	Global.deck = Deck.new()
	current_health = max_health
	current_endurance = max_endurance


func spawn_player(node: Node, position: Vector2 = Vector2.ZERO):
	player = load(FileFunction.get_file_list(Global.PLAYER_DIRECTORY).get(classes)).instantiate()
	player.position = position
	node.add_child(player)
	
	for effect: Effect in effects:
		player.effect_machine.add_child(effect.instantiate())

func get_effect():
	var get_effect: Array[Effect]
	for effect: Effect in player.effect_machine.get_children():
		get_effect.append(effect)
	effects.clear()
	effects.append_array(get_effect)

func clear_effect():
	effects.clear()

func clear_item():
	effects.clear()

func reset():
	classes = ""
	Global.deck = Deck.new()
	print("/[reset]")

func compute_player_wealth():
	var classes_price: int = 0
	var ability_price: int = 0
	var card_price: int = 0
	
	classes_price = Global.classes_data.property.get(classes).price
	for i in Global.deck.head_pile:
		if i:
			if i.item:
				card_price += i.item.price
	
	wealth = (classes_price + card_price + ability_price)
	print("[player_wealth] => ", wealth)

func update_classes(v):
	classes = Global.classes_data.classes_name.get(v)
	max_health = Global.classes_data.property.get(v).max_health
	max_endurance = Global.classes_data.property.get(v).max_endurance
	current_health = max_health
	current_endurance = max_endurance

	weapon_update.emit()
	health_changed.emit()
	endurance_changed.emit()
	
	print("[player classes update] => ", classes)
