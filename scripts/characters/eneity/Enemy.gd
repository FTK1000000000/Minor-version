extends Entity
class_name Enemy

signal health_changed


@onready var body_texture: Sprite2D = $Texture/Body
@onready var aim_line: ColorRect = $Texture/AimLine
@onready var hud: Node2D = $Texture/HUD
@onready var health_bar: TextureProgressBar = $Texture/HUD/health_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var AAP: AnimationPlayer = $AnimationPlayer
@onready var HEAP: AnimationPlayer = $HurtEffectPlayer
@onready var hurt_effect_timer: Timer = $HurtEffectTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var hitbox: Area2D = $HitBox
@onready var navigation_agent : NavigationAgent2D = $Nav/NavigationAgent2D
@onready var path_timer: Timer = $Nav/PathTimer
@onready var attack_ranged_collision: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var body_collision: CollisionShape2D = $CollisionShape2D
@onready var state_chart: StateChart = $EnemyStateChart

@export var aggro_target: CharacterBody2D
@export var attack_target: CharacterBody2D
var target_position: Vector2

@export var data_name: String
@export var move_speed: int = 100
@export var current_move_speed: int
@export var attack_range: int
@export var attack_ready_time: float
@export var attack_damage: int

@export var attack_is_ready: bool = false
@export var is_can_attack: bool = false

@export var is_chase: bool = false
@export var is_attack: bool = false

var is_flip: bool = false
var is_dead: bool = false
var deading: bool = false


func _ready():
	read_data()
	current_move_speed = move_speed
	current_health = max_health
	hitbox.damage = attack_damage
	aim_line.size.x = attack_ranged_collision.shape.radius
	attack_is_ready = true
	
	var v = attack_ranged_collision.shape.radius - body_collision.shape.radius * 2
	navigation_agent.target_desired_distance = v
	navigation_agent.path_desired_distance = 10


func _process(_delta):
	update_state()
	update_animation()
	handle_health()
	
	if navigation_agent.is_navigation_finished():
		return
	
	var axis = to_local(navigation_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * current_move_speed
	navigation_agent.set_velocity(intended_velocity)


func update_state():
	if is_dead:
		state_chart.send_event("dead")
		is_dead = false
	
	if !aggro_target:
		state_chart.send_event("idle")
	
	else:
		if attack_target:
			state_chart.send_event("attack")
		elif attack_is_ready:
			state_chart.send_event("chase")
#更新状态

func update_animation():
	if is_dead: return
	
	if aggro_target:
		var m = (global_position - aggro_target.position).normalized()
		
		if m.x > 0:
			body_texture.flip_h = true
		else:
			body_texture.flip_h = false
#纹理朝向和渲染索引

func handle_health():
	if current_health != max_health:
		health_bar.visible = true
	if current_health <= 0 && !deading:
		GlobalPlayerState.player_kill += 1
		
		is_dead = true
		deading = true
#血量操作

func recalc_path():
	if aggro_target:
		get_path_to_player()
	else:
		navigation_agent.target_position = position

func get_path_to_player():
	navigation_agent.target_position = aggro_target.global_position

func read_data():
	if !data_name:
		return
	
	var data = Global.enemy_data.get(data_name)
	
	move_speed = data.move_speed
	max_health = data.max_health
	attack_damage = data.attack_damage
	attack_ready_time = data.attack_ready_time
	attack_timer.wait_time = attack_ready_time

func aimline_rotation():
	var tg = aggro_target.global_position
	var g = global_position
	var tr: Vector2 = (tg - g).normalized()
	
	if aggro_target && attack_is_ready:
		aim_line.rotation = tr.angle()


func _on_attack_range_area_entered(area: Area2D) -> void:
	attack_target = area.owner
	attack_is_ready = true


func _on_attack_range_area_exited(area: Area2D) -> void:
	if area.owner == attack_target:
		attack_target = null
	attack_is_ready = false


func _on_timer_timeout():
	recalc_path()


func _on_aggro_range_area_entered(area):
	aggro_target = area.owner


func _on_de_aggro_range_area_exited(area):
	if area.owner == aggro_target:
		aggro_target = null


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()


func _on_idle_state_entered() -> void:
	animation_player.play("idle")
	current_move_speed = 0


func _on_chase_state_entered() -> void:
	animation_player.play("walk")
	current_move_speed = move_speed
	is_chase = true


func _on_chase_state_exited() -> void:
	is_chase = false


func _on_hurt_state_entered() -> void:
	health_changed.emit()
	HEAP.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	HEAP.play("RESET")


func _on_dead_state_entered() -> void:
	hud.hide()
	current_move_speed = 0
	hitbox.set_deferred("monitorable", false)
	HEAP.play("dead_fog")
	await HEAP.animation_finished
	
	queue_free()
