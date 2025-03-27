extends Entity
class_name Enemy


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_hitbox: Hitbox = $CollisionHitbox
@onready var can_attack_ranged_collision: CollisionShape2D = $CanAttackRange/CollisionShape2D
@onready var melee_attack_hitbox: Node2D = $MeleeAttackHitbox
@onready var aggro_range: CollisionShape2D = $Aggro/AggroRange/CollisionShape2D
@onready var de_aggro_range: CollisionShape2D = $Aggro/DeAggroRange/CollisionShape2D
@onready var can_attack_range: CollisionShape2D = $CanAttackRange/CollisionShape2D
@onready var navigation_agent : NavigationAgent2D = $Nav/NavigationAgent2D
@onready var popup_location: Marker2D = $PopupLocation
@onready var hud: Node2D = $Texture/HUD
@onready var health_bar: TextureProgressBar = $Texture/HUD/health_bar
@onready var aim_line: ColorRect = $Texture/AimLine
@onready var attack_timer: Timer = $AttackTimer
@onready var path_timer: Timer = $Nav/PathTimer

@export var aggro_target: CharacterBody2D
@export var attack_target: CharacterBody2D
@export var target_position: Vector2
var state_tween: Tween

@export var data_name: String
@export var move_speed: int = 100
@export var current_move_speed: int

var collision_knockback_force: int
var collision_damage: int

var attack_ready_time: float
var melee_attack_damage: int

@export var is_melee_area_rotation: bool = false
var attack_is_ready: bool = true
var is_can_attack: bool = false
var is_flip: bool = false

var is_spawn: bool = false
var is_chase: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_range: bool = false


func _ready():
	super()
	read_data()
	current_move_speed = move_speed
	current_health = max_health
	collision_hitbox.knockback_force = collision_knockback_force
	collision_hitbox.damage = collision_damage
	
	navigation_agent.target_desired_distance = \
		can_attack_ranged_collision.shape.radius - compute_collision_shape_use_size()
	navigation_agent.path_desired_distance = 10

func _process(_delta):
	if is_dead || is_spawn: return
	update_state()
	update_animation()
	
	if navigation_agent.is_navigation_finished(): return
	
	var axis = to_local(navigation_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * current_move_speed
	navigation_agent.set_velocity(intended_velocity)

func _physics_process(delta: float) -> void:
	move_and_slide()

func dead_handle():
	state_chart.send_event("dead")

func hurt_handle():
	state_chart.send_event("hurt")


func read_data():
	if !data_name: return
	var data = Global.enemy_data.get(data_name)
	move_speed = data.move_speed_multiple * Common.move_speed
	max_health = data.max_health
	collision_knockback_force = data.collision.knockback_force
	collision_damage = data.collision.damage
	melee_attack_damage = data.melee.damage if "melee" in data else 0
	is_melee_area_rotation = data.melee.is_melee_area_rotation if "melee" in data else false
	aggro_range.shape.radius = data.aggro_range
	de_aggro_range.shape.radius = data.de_aggro_range
	can_attack_range.shape.radius = data.can_attack_range
	attack_ready_time = data.attack_ready_time
	attack_timer.wait_time = attack_ready_time
	
	if "effects" in data.collision:
		var collision_effects: Array = []
		for new_effect: Dictionary in data.collision.effects:
			for effect: Dictionary in collision_effects:
				if new_effect.get(effect.name) in effect:
					new_effect.time = (
						new_effect.time
						if new_effect.time > effect.time else
						effect.time
						)
					collision_effects.erase(effect)
			collision_effects.push_back(new_effect)
		collision_hitbox.effects.append_array(collision_effects)

func update_state():
	if !aggro_target && !is_idle:
		state_chart.send_event("idle")
	else:
		if attack_target && !is_attack:
			state_chart.send_event("attack")
		elif attack_is_ready && !is_chase:
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
		get_path_to_target()
	else:
		navigation_agent.target_position = position

func get_path_to_target():
	navigation_agent.target_position = aggro_target.global_position

func compute_collision_shape_use_size() -> float:
	var v
	match collision_shape_2d.shape.get_class():
		"CircleShape2D":
			v = collision_shape_2d.shape.radius * 2
		"RectangleShape2D":
			if collision_shape_2d.shape.size.x < collision_shape_2d.shape.size.y:
				v = collision_shape_2d.shape.size.x
			else:
				v = collision_shape_2d.shape.size.y
	return v as float if !(v is float) else v

func update_aimline_size():
	var x = global_position.x - target_position.x
	var y = global_position.y - target_position.y
	if x < 0: x = x - x - x
	if y < 0: y = y - y - y
	var v = x if x > y else y
	aim_line.size.x = v

func aimline_rotation():
	var tg = attack_target.global_position
	var g = global_position
	var tr: Vector2 = (tg - g).normalized()
	
	if attack_target && attack_is_ready:
		aim_line.rotation = tr.angle()

func melee_area_rotation():
	var tg = attack_target.global_position
	var g = global_position
	var tr: Vector2 = (tg - g).normalized()
	
	if attack_target && attack_is_ready:
		melee_attack_hitbox.rotation = tr.angle()


func _on_path_timer_timeout():
	recalc_path()


func _on_attack_range_area_entered(area: PlayerHurtbox) -> void:
	attack_is_ready = true
	attack_target = area.owner


func _on_attack_range_area_exited(area: PlayerHurtbox) -> void:
	attack_is_ready = false
	if area.owner == attack_target:
		attack_target = null


func _on_aggro_range_area_entered(area):
	aggro_target = area.owner


func _on_de_aggro_range_area_exited(area):
	if area.owner == aggro_target:
		aggro_target = null


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()


func _on_hurt_state_entered() -> void:
	if !is_hurt:
		is_hurt = true
	health_changed.emit()
	hurt_effect_player.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	hurt_effect_player.play("RESET")
	if state_tween:
		state_tween.kill()


func _on_dead_state_entered() -> void:
	if !is_dead:
		is_dead = true
	hud.hide()
	current_move_speed = 0
	collision_hitbox.set_deferred("monitorable", false)
	state_player.play("enemy/dead")
	await state_player.animation_finished
	
	queue_free()


func _on_idle_state_entered() -> void:
	if !is_idle:
		is_idle = true
	state_player.play("idle")
	current_move_speed = 0


func _on_spawn_state_entered() -> void:
	if !is_spawn:
		is_spawn = true
	state_player.play("enemy/spawn")


func _on_spawn_state_exited() -> void:
	is_spawn = false


func _on_chase_state_entered() -> void:
	if !is_chase:
		is_chase = true
	state_player.play("walk")
	current_move_speed = move_speed


func _on_chase_state_exited() -> void:
	is_chase = false


func _on_melee_state_entered() -> void:
	if !is_melee:
		is_melee = true


func _on_melee_state_exited() -> void:
	is_melee = false


func _on_ranged_state_entered() -> void:
	if !is_range:
		is_range = true


func _on_ranged_state_exited() -> void:
	is_range = false
