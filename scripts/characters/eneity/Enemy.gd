extends CharacterBody2D

class_name Enemy

enum Direction {
	LEFT,
	RIGHT
}

@onready var animation_player = $AnimationPlayer
@onready var textrule : Node2D = $Textrule
@onready var nav_agent : NavigationAgent2D = $Nav/NavigationAgent2D
@onready var hit_box = $HitBox

@export var direction :  Direction

@export var target_node : Node2D

var home_pos = Vector2.ZERO

var towards : Vector2 = Vector2.ZERO

var move_speed : float = 75

var is_dead : bool = false

func _ready():
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4


func _process(_delta):
	if nav_agent.is_navigation_finished():
		return
		
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * move_speed
	nav_agent.set_velocity(intended_velocity)
	
	if is_dead: return

func recalc_path():
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = position


func _on_timer_timeout():
	recalc_path()


func _on_aggro_range_area_entered(area):
	target_node = area.owner


func _on_de_aggro_range_area_exited(area):
	if area.owner == target_node:
		target_node = null


func _on_navigation_agent_2d_velocity_computed(_safe_velocity):
	velocity = _safe_velocity
	move_and_slide()


func _on_hurt_box_area_entered(area):
	if area == hit_box: return
	is_dead = true
	hit_box.set_deferred("monitorable", false)
	animation_player.play("dead_fog")
	await animation_player.animation_finished
	queue_free()
