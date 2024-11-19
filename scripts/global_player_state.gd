extends Node

signal classes_select


const CLASSES_DATA_PATH = "res://classes_data.json"


@export var classes_data: Dictionary = {}

@export var player: Player
@export var player_classes: String = ""
@export var player_weapon: String = ""
@export var player_max_health: int = 100
@export var player_max_endurance: int = 100
@export var player_walk_move_speed: int = 100
@export var player_run_move_speed: int = 200

@export var player_current_health: int
@export var player_current_endurance: int
@export var endurance_recover_amount: int = 10
@export var endurance_recover_ready: int = 1
@export var endurance_recover_speed: float = 0.2
@export var endurance_recover_ready_speed: float = 0.5
@export var knockback_power: int = 3000

@export var player_ability: Array = []
@export var remainder_ability: Array = []
@export var common_ability: Array = []
#tank
@export var weapon_attack_twice = false
#hunter
@export var sturdy_shield = false
#mage
@export var rapid_fire = false

@export var money: int = 0
@export var player_kill: int = 0
@export var player_dead: bool = false


func _ready() -> void:
	get_classes_data()
	classes_select.connect(update_classes)
	
	player_current_health = player_max_health
	player_current_endurance = player_max_endurance


func get_classes_data():
	var file = FileAccess.open(CLASSES_DATA_PATH, FileAccess.READ)
	var json = file.get_as_text()
	var data = JSON.parse_string(json) as Dictionary
	
	classes_data = data
	common_ability = data.ability.common.keys()

func update_classes(classes_name, weapon, max_health, max_endurance):
	player_classes = classes_name
	player_weapon = str(weapon)
	player_max_health = max_health
	player_max_endurance = max_endurance
	player_current_health = max_health
	player_current_endurance = max_endurance
	player.current_health = player_max_health
	player.current_endurance = player_max_endurance
	player.weapon_node.add_child(load(player_weapon).instantiate())
	player.weapon_update.emit()
	player.health_changed.emit()
	player.endurance_changed.emit()
	
	remainder_ability = classes_data.ability.get(player_classes).keys()
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
		player_walk_move_speed += 50
	
	if ability_name == "more_run_speed":
		player_run_move_speed += 50
	
	player.weapon_update.emit()
	player.health_changed.emit()
	player.endurance_changed.emit()

func update_ability():
	if player_ability.has("more_health"):
		player_max_health += (player_ability.count("more_health") * 50)
	
	if player_ability.has("more_endurance"):
		player_max_endurance += (player_ability.count("more_endurance") * 50)
	
	if player_ability.has("more_walk_speed"):
		player_walk_move_speed += (player_ability.count("more_walk_speed") * 50)
	
	if player_ability.has("more_run_speed"):
		player_run_move_speed += (player_ability.count("more_run_speed") * 50)
	
	if player_ability.has("weapon_attack_twice"):
		weapon_attack_twice = true
	
	if player_ability.has("sturdy_shield"):
		sturdy_shield = true
	
	if player_ability.has("rapid_fire"):
		rapid_fire = true

func clear_date():
	classes_data = {}
	player_ability = []
