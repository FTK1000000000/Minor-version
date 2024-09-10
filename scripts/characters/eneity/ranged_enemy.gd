extends Enemy

class_name RangedEnemy


@onready var ranged_attack_timer: Timer = $RangedAttackTimer

var ammo = preload("res://characters/derivative/ammo.tscn")

var max_distance_to_player: int = 160
var min_distance_to_player: int = 128
var distance_to_player: float

var projectile_speed: int = 200
var can_attack: bool = true


func _ready():
	navigation_agent.path_desired_distance = 4
	navigation_agent.target_desired_distance = 4
	move_speed = 175

func recalc_path():
	if target_node:
		distance_to_player = (target_node.position - global_position).length()
		if distance_to_player > max_distance_to_player:
			get_path_to_player()
		elif  distance_to_player < min_distance_to_player:
			get_path_to_move_away_from_player()
		else:
			if can_attack:
				can_attack = false
				ranged_attack()
				ranged_attack_timer.start()
#寻路

func get_path_to_move_away_from_player():
	var dir: Vector2 = (global_position - target_node.position).normalized()
	navigation_agent.target_position = target_node.global_position + dir * min_distance_to_player

func ranged_attack():
	var projectile: Area2D = ammo.instantiate()
	
	projectile.launch(global_position, (target_node.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)


func _on_ranged_attack_timer_timeout() -> void:
	can_attack = true


func _on_idle_state_entered() -> void:
	if distance_to_player > max_distance_to_player || distance_to_player < min_distance_to_player:
		state_chart.send_event("chase")


func _on_chase_state_entered() -> void:
	if distance_to_player < max_distance_to_player && distance_to_player > min_distance_to_player:
		state_chart.send_event("idle")
