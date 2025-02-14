extends Entity
class_name Enemy


@onready var aim_line: ColorRect = $Texture/AimLine
@onready var hud: Node2D = $Texture/HUD
@onready var health_bar: TextureProgressBar = $Texture/HUD/health_bar
@onready var attack_timer: Timer = $AttackTimer
@onready var hitbox: Hitbox = $Hitbox
@onready var navigation_agent : NavigationAgent2D = $Nav/NavigationAgent2D
@onready var path_timer: Timer = $Nav/PathTimer
@onready var attack_ranged_collision: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var aggro_range: CollisionShape2D = $Aggro/AggroRange/CollisionShape2D
@onready var de_aggro_range: CollisionShape2D = $Aggro/DeAggroRange/CollisionShape2D
@onready var attack_range: CollisionShape2D = $AttackRange/CollisionShape2D
@onready var popup_location: Marker2D = $PopupLocation

@export var aggro_target: CharacterBody2D
@export var attack_target: CharacterBody2D
@export var target_position: Vector2

@export var data_name: String
@export var move_speed: int = 100
@export var current_move_speed: int
@export var attack_ready_time: float


@export var collision_knockback_force: int
@export var collision_damage: int

var attack_is_ready: bool = true
var is_can_attack: bool = false
var is_flip: bool = false

var is_chase: bool = false
var is_attack: bool = false


func _ready():
	super()
	read_data()
	current_move_speed = move_speed
	current_health = max_health
	hitbox.knockback_force = collision_knockback_force
	hitbox.damage = collision_damage
	aim_line.size.x = attack_ranged_collision.shape.radius
	
	var v = attack_ranged_collision.shape.radius - collision_shape_2d.shape.radius * 2
	navigation_agent.target_desired_distance = v
	navigation_agent.path_desired_distance = 10
	

func _process(_delta):
	if is_dead: return
	update_state()
	update_animation()
	health_handle()
	
	if navigation_agent.is_navigation_finished(): return
	
	var axis = to_local(navigation_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * current_move_speed
	navigation_agent.set_velocity(intended_velocity)

func dead_handle():
	state_chart.send_event("dead")

func hurt_handle():
	state_chart.send_event("hurt")


func health_handle():
	pass

func update_state():
	if !aggro_target:
		state_chart.send_event("idle")
	
	else:
		if attack_target:
			state_chart.send_event("attack")
		elif attack_is_ready:
			state_chart.send_event("chase")
#更新状态

func update_animation():
	if aggro_target:
		var m = (global_position - aggro_target.position).normalized()
		
		if m.x > 0:
			body_texture.flip_h = true
		else:
			body_texture.flip_h = false
#纹理朝向和渲染索引

func recalc_path():
	if aggro_target:
		get_path_to_player()
	else:
		navigation_agent.target_position = position

func get_path_to_player():
	navigation_agent.target_position = aggro_target.global_position

func read_data():
	if !data_name: return
	var data = Global.enemy_data.get(data_name)
	move_speed = data.move_speed_multiple * Common.move_speed
	max_health = data.max_health
	collision_knockback_force = data.collision.knockback_force
	collision_damage = data.collision.damage
	aggro_range.shape.radius = data.aggro_range
	de_aggro_range.shape.radius = data.de_aggro_range
	attack_range.shape.radius = data.attack_range
	attack_ready_time = data.attack_ready_time
	attack_timer.wait_time = attack_ready_time

func aimline_rotation():
	var tg = aggro_target.global_position
	var g = global_position
	var tr: Vector2 = (tg - g).normalized()
	
	if aggro_target && attack_is_ready:
		aim_line.rotation = tr.angle()


func _on_path_timer_timeout():
	recalc_path()


func _on_attack_range_area_entered(area: PlayerHurtbox) -> void:
	attack_target = area.owner
	attack_is_ready = true


func _on_attack_range_area_exited(area: PlayerHurtbox) -> void:
	if area.owner == attack_target:
		attack_target = null
	attack_is_ready = false


func _on_aggro_range_area_entered(area):
	aggro_target = area.owner


func _on_de_aggro_range_area_exited(area):
	if area.owner == aggro_target:
		aggro_target = null


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()


func _on_idle_state_entered() -> void:
	state_player.play("idle")
	current_move_speed = 0


func _on_chase_state_entered() -> void:
	state_player.play("walk")
	current_move_speed = move_speed
	is_chase = true


func _on_chase_state_exited() -> void:
	is_chase = false


func _on_hurt_state_entered() -> void:
	health_changed.emit()
	hurt_effect_player.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	hurt_effect_player.play("RESET")


func _on_dead_state_entered() -> void:
	if !is_dead:
		is_dead = true
	hud.hide()
	current_move_speed = 0
	hitbox.set_deferred("monitorable", false)
	state_player.play("enemy/dead")
	await state_player.animation_finished
	
	queue_free()
