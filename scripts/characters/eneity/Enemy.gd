extends CharacterBody2D
class_name Enemy

signal health_changed


@onready var textrule : Node2D = $Texture
@onready var UI: Node2D = $Texture/UI
@onready var health_bar: TextureProgressBar = $Texture/UI/health_bar
@onready var AAP: AnimationPlayer = $ActionPlayer
@onready var HEAP: AnimationPlayer = $HurtEffectPlayer
@onready var hurt_effect_timer: Timer = $HurtEffectTimer
@onready var hitbox: Area2D = $HitBox
@onready var navigation_agent : NavigationAgent2D = $Nav/NavigationAgent2D
@onready var path_timer: Timer = $Nav/PathTimer
@onready var state_chart: StateChart = $StateChart

@export var target_node: CharacterBody2D
var home_pos = Vector2.ZERO

var towards : Vector2 = Vector2.ZERO

@export var move_speed : float = 75
var knockback_power : int = 300
var max_health : int = 20
var current_health : int = 20

var is_dead: bool = false
var deading: bool = false


func _ready():
	navigation_agent.path_desired_distance = 4
	navigation_agent.target_desired_distance = 1
	
	hitbox.damage = 10


func _process(_delta):
	update_state()
	handle_health()
	
	if navigation_agent.is_navigation_finished():
		return
		
	var axis = to_local(navigation_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * move_speed
	navigation_agent.set_velocity(intended_velocity)


func update_state():
	if is_dead:
		state_chart.send_event("dead")
		is_dead = false
	if !target_node: state_chart.send_event("idle")
	elif target_node: state_chart.send_event("chase")
#更新状态

func handle_health():
	if current_health != max_health:
		health_bar.visible = true
	if current_health <= 0 && !deading:
		Global.player_kill += 1
		
		is_dead = true
		deading = true
#血量操作

func recalc_path():
	if target_node:
		get_path_to_player()
	else:
		navigation_agent.target_position = position

func get_path_to_player():
	navigation_agent.target_position = target_node.global_position


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


func _on_dead_state_entered() -> void:
	UI.visible = false
	move_speed = 0
	hitbox.set_deferred("monitorable", false)
	AAP.play("dead_fog")
	await AAP.animation_finished
	
	queue_free()


func _on_idle_state_entered() -> void:
	pass


func _on_chase_state_entered() -> void:
	pass


func _on_hurt_state_entered() -> void:
	health_changed.emit()
	HEAP.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	HEAP.play("RESET")
