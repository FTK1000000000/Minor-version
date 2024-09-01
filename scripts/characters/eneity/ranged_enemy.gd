extends Enemy

class_name RangedEnemy


var ammo = preload("res://characters/derivative/ammo.tscn")

var max_distance_to_player: int = 128
var min_distance_to_player: int = 96
var distance_to_player: int = 96

var projectile_speed: int = 150
var can_attack: bool = true

func _ready():
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 128


func get_projectile():
	var projectile: Area2D = ammo.instantiate()
	projectile.launch(global_position, (target_node.position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)


func _on_ranged_attack_timer_timeout() -> void:
	can_attack = true
