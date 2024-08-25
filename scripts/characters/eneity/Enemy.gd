extends CharacterBody2D

class_name Enemy

signal health_changed

enum Direction {
	LEFT,
	RIGHT
}

@onready var animation_player = $AnimationPlayer
@onready var textrule : Node2D = $Textrule
@onready var nav_agent : NavigationAgent2D = $Nav/NavigationAgent2D
@onready var cling = $Textrule/Cling
@onready var health_bar = $Textrule/Cling/health_bar
@onready var hurt_effect = $HurtEffect
@onready var hurt_effect_timer = $HurtEffectTimer
@onready var hurt_box = $HurtBox
@onready var hit_box = $HitBox

@export var direction :  Direction

@export var target_node : Node2D
var home_pos = Vector2.ZERO

var towards : Vector2 = Vector2.ZERO

var move_speed : float = 75
var knockback_power : int = 300
var max_health : int = 20
@export var current_health : int = 20

var is_hurt : bool = false

var is_dead : bool = false

func _ready():
	nav_agent.path_desired_distance = 4
	nav_agent.target_desired_distance = 4


func _process(_delta):
	handle_health()
	
	if nav_agent.is_navigation_finished():
		return
		
	var axis = to_local(nav_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * move_speed
	nav_agent.set_velocity(intended_velocity)
	
	if is_dead: return
	
	if !is_hurt:
		for area in hurt_box.get_overlapping_areas():
			if area.name == "HitBox":
				hurt_by_enemy(area)

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

func hurt_by_enemy(area):
	current_health -= 10
	health_changed.emit()
	is_hurt = true
	#knockback(area.get_parent().velocity)
	hurt_effect.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	hurt_effect.play("RESET")
	is_hurt = false

func knockback(node_velocity : Vector2):
	var knockback_direction = (node_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()

func handle_health():
	if current_health != max_health:
		health_bar.visible = true
	if current_health <= 0 :
		is_dead = true
	
	if is_dead:
		cling.visible = false
		
		move_speed = 0
		
		hit_box.set_deferred("monitorable", false)
		animation_player.play("dead_fog")
		await animation_player.animation_finished
		queue_free()

