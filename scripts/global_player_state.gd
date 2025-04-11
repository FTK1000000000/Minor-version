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
@export var classes: String
@export var max_head_card_amount: int = 7
@export var wealth: int = 100:
	set(v):
		wealth = v
		
		#dark styem
		var vignette = Global.HUD.vignette
		var dark_level
		for i in vignette.level_intensity:
			if vignette.level_intensity.get(i).get("price") <= wealth:
				dark_level = i
		vignette.level = dark_level
@export var max_health: int = 100
@export var max_endurance: int = 100
@export var move_speed: int = Common.move_speed
@export var walk_move_speed_multiple: float = 1.0
@export var run_move_speed_multiple: float = 2.0
@export var current_move_speed_multiple: float = 1.0

@export var current_health: int:
	set(v):
		current_health = v
		if player:
			player.current_health = v
@export var current_endurance: int:
	set(v):
		current_endurance = v
		if player:
			player.current_endurance = v
@export var endurance_recover_amount: int = 10
@export var endurance_recover_ready: int = 1
@export var endurance_recover_speed: float = 0.2
@export var endurance_recover_ready_speed: float = 0.5
@export var knockback_power: int = 300

@export var current_ability: Array = []
@export var remainder_ability: Array = []
@export var common_ability: Array = []

@export var money: int = 0
@export var kill: int = 0

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
	current_health = max_health
	current_endurance = max_endurance


#func set_weapon_state(name: String, attack_consume_endurance: String):
	#var v = {}
	#v.name
	#v.attack_consume_endurance
#
#func get_weapon_state() -> Dictionary:
	#pass

func spawn_player(node: Node, position: Vector2 = Vector2.ZERO):
	player = load(FileFunction.get_file_list(Global.PLAYER_DIRECTORY).get(classes)).instantiate()
	player.position = position
	node.add_child(player)

func reset():
	classes = ""
	#weapon = null
	current_ability = []
	current_ability = []
	remainder_ability = []
	Global.deck = Deck.new()
	print("/[reset]")

func compute_player_wealth():
	var classes_price: int = 0
	var ability_price: int = 0
	#var weapon_price: int = 0
	var card_price: int = 0
	
	classes_price = Global.classes_data.property.get(classes).price
	#weapon_price = Global.weapon_data.get(weapon).price
	for i in Global.deck.head_pile:
		if i:
			if i.item:
				card_price += i.item.price
	for i in current_ability:
		ability_price += Global.ability_data.list.get(i).price
	
	wealth = (classes_price + card_price + ability_price)
	print("[player_wealth] => ", wealth)

func update_classes(v):
	classes = Global.classes_data.classes_name.get(v)
	#weapon = Global.classes_data.weapon.get(classes)
	max_health = Global.classes_data.property.get(v).max_health
	max_endurance = Global.classes_data.property.get(v).max_endurance
	current_health = max_health
	current_endurance = max_endurance
	#player.current_health = max_health
	#player.current_endurance = max_endurance
	#player.weapon_node.add_child(load(Global.weapon_data.get(weapon).path).instantiate())
	weapon_update.emit()
	health_changed.emit()
	endurance_changed.emit()
	
	remainder_ability = Global.ability_data.classes.get(classes)
	print("[player classes update] => ", classes)

func get_ability(ability_name):
	remainder_ability.erase(ability_name)
	current_ability.append(ability_name)
	#update_ability()
	
	if ability_name == "more_health":
		max_health += 50
		current_health += 50
	
	if ability_name == "more_endurance":
		max_endurance += 50
		current_endurance += 50
	
	if ability_name == "more_walk_speed":
		move_speed += 20
	
	if ability_name == "more_run_speed":
		run_move_speed_multiple += 0.25
	
	weapon_update.emit()
	health_changed.emit()
	endurance_changed.emit()

func update_ability():
	if current_ability.has("more_health"):
		max_health += (current_ability.count("more_health") * 50)
	
	if current_ability.has("more_endurance"):
		max_endurance += (current_ability.count("more_endurance") * 50)
	
	if current_ability.has("more_walk_speed"):
		move_speed += (current_ability.count("more_walk_speed") * 20)
	
	if current_ability.has("more_run_speed"):
		run_move_speed_multiple += (current_ability.count("more_run_speed") * 0.2)
	
	if current_ability.has("weapon_attack_twice"):
		weapon_attack_twice = true
	
	if current_ability.has("sturdy_shield"):
		sturdy_shield = true
	
	if current_ability.has("rapid_fire"):
		rapid_fire = true
