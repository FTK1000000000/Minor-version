extends Node

signal classes_select
signal weapon_update
signal update_variable
signal health_changed
signal endurance_changed
signal money_changed
signal player_dead


@export var player: Player
@export var player_max_head_card_amount: int = 7
@export var player_classes: String
@export var player_weapon: String
@export var player_wealth: int = 100
@export var player_max_health: int = 100
@export var player_max_endurance: int = 100
@export var player_move_speed: int = 100
@export var player_walk_move_speed_multiple: float = 1.0
@export var player_run_move_speed_multiple: float = 2.0
@export var player_current_move_speed_multiple: float = 1.0

@export var player_current_health: int
@export var player_current_endurance: int
@export var endurance_recover_amount: int = 10
@export var endurance_recover_ready: int = 1
@export var endurance_recover_speed: float = 0.2
@export var endurance_recover_ready_speed: float = 0.5
@export var knockback_power: int = 300

@export var player_ability: Array = []
@export var remainder_ability: Array = []
@export var common_ability: Array = []

@export var money: int = 0
@export var player_kill: int = 0

#for tank
var weapon_attack_twice = false
#for hunter
@export var dodge_length: int = 1000
@export var dodge_endurance_consume: int = 30
@export var dodge_ready_time: float = 3
@export var dodge_time: float = 0.2

var sturdy_shield = false
#for mage
var rapid_fire = false


func _ready() -> void:
	classes_select.connect(update_classes)
	
	Global.deck = Deck.new()
	player_current_health = player_max_health
	player_current_endurance = player_max_endurance


func spawn_player(node: Node, position: Vector2 = Vector2.ZERO):
	player = load(FileFunction.get_file_list(Global.PLAYER_DIRECTORY).get(player_classes)).instantiate()
	player.position = position
	node.add_child(player)

func reset():
	player_classes = ""
	player_weapon = ""
	player_ability = []
	remainder_ability = []
	print("/[reset]")

func compute_player_wealth():
	var classes_price: int = 0
	var ability_price: int = 0
	var weapon_price: int = 0
	var card_price: int = 0
	
	classes_price = Global.classes_data.property.get(player_classes).price
	weapon_price = Global.weapon_data.get(player_weapon).price
	for i in Global.deck.head_pile.slots:
		if i.item:
			card_price += i.item.price
	for i in player_ability:
		ability_price += Global.ability_data.list.get(i).price
	
	player_wealth = (classes_price + weapon_price + card_price + ability_price)
	print("[player_wealth] => ", player_wealth)

func update_classes(classes):
	player_classes = Global.classes_data.classes_name.get(classes)
	player_weapon = Global.classes_data.weapon.get(classes)
	player_max_health = Global.classes_data.property.get(classes).max_health
	player_max_endurance = Global.classes_data.property.get(classes).max_endurance
	player_current_health = player_max_health
	player_current_endurance = player_max_endurance
	#player.current_health = player_max_health
	#player.current_endurance = player_max_endurance
	#player.weapon_node.add_child(load(Global.weapon_data.get(player_weapon).path).instantiate())
	weapon_update.emit()
	health_changed.emit()
	endurance_changed.emit()
	
	remainder_ability = Global.ability_data.classes.get(player_classes)
	print("[player classes update] => ", player_classes)

func get_ability(ability_name):
	remainder_ability.erase(ability_name)
	player_ability.append(ability_name)
	#update_ability()
	
	if ability_name == "more_health":
		player_max_health += 50
		player_current_health += 50
	
	if ability_name == "more_endurance":
		player_max_endurance += 50
		player_current_endurance += 50
	
	if ability_name == "more_walk_speed":
		player_move_speed += 20
	
	if ability_name == "more_run_speed":
		player_run_move_speed_multiple += 0.25
	
	weapon_update.emit()
	health_changed.emit()
	endurance_changed.emit()

func update_ability():
	if player_ability.has("more_health"):
		player_max_health += (player_ability.count("more_health") * 50)
	
	if player_ability.has("more_endurance"):
		player_max_endurance += (player_ability.count("more_endurance") * 50)
	
	if player_ability.has("more_walk_speed"):
		player_move_speed += (player_ability.count("more_walk_speed") * 20)
	
	if player_ability.has("more_run_speed"):
		player_run_move_speed_multiple += (player_ability.count("more_run_speed") * 0.2)
	
	if player_ability.has("weapon_attack_twice"):
		weapon_attack_twice = true
	
	if player_ability.has("sturdy_shield"):
		sturdy_shield = true
	
	if player_ability.has("rapid_fire"):
		rapid_fire = true

func clear_date():
	Global.classes_data = {}
	player_ability = []
