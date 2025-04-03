extends Entity
class_name Enemy


@onready var hud: Node2D = $Texture/HUD
@onready var health_bar: TextureProgressBar = $Texture/HUD/health_bar
@onready var popup_location: Marker2D = $Texture/HUD/PopupLocation
@onready var aim_line: ColorRect = $Texture/AimLine
@onready var body_collision: CollisionShape2D = $BodyCollision
@onready var collision_hitbox: Hitbox = $CollisionHitbox
@onready var aggro_range: CollisionShape2D = $Aggro/AggroRange/CollisionShape2D
@onready var de_aggro_range: CollisionShape2D = $Aggro/DeAggroRange/CollisionShape2D
@onready var navigation_agent : NavigationAgent2D = $Navigation/NavigationAgent2D
@onready var melee_attack_range: CollisionShape2D = $Melee/AttackRange/CollisionShape2D
@onready var melee_attack_timer: Timer = $Melee/AttackTimer
@onready var melee_attack_hitboxs: Node2D = $Melee/Hitboxs
@onready var range_attack_range: CollisionShape2D = $Range/AttackRange/CollisionShape2D
@onready var range_attack_timer: Timer = $Range/AttackTimer

var aggro_target: Array[CharacterBody2D]
var attack_target: CharacterBody2D
var attack_position: Vector2
var state_tween: Tween

@export var data_name: String
var move_speed: int = 100
var current_move_speed: int
var projectile: PackedScene
var projectile_speed: int
var max_range_attack_distance: int
var min_range_attack_distance: int
var attack_range: Dictionary
var attack_ready_time: Dictionary
var attack_knockback: Dictionary
var attack_damage: Dictionary

var can_attack: bool = false
var can_melee: bool = false
var can_range: bool = false
var is_flip: bool = false
@export var is_spawn: bool = false
var is_chase: bool = false
var is_attack: bool = false
var is_melee: bool = false
var is_range: bool = false


func _ready():
	super()
	read_data()
	aggro_range.shape = aggro_range.shape.duplicate()
	de_aggro_range.shape = de_aggro_range.shape.duplicate()
	melee_attack_range.shape = melee_attack_range.shape.duplicate()
	range_attack_range.shape = range_attack_range.shape.duplicate()
	
	current_move_speed = move_speed
	current_health = max_health
	collision_hitbox.ready_time = attack_ready_time.collision
	collision_hitbox.knockback_force = attack_knockback.collision
	collision_hitbox.damage = attack_damage.collision
	if "melee" in attack_ready_time:
		melee_attack_range.shape.radius = attack_range.melee
		melee_attack_timer.wait_time = attack_ready_time.melee
		for node: Hitbox in melee_attack_hitboxs.get_children():
			node.ready_time = attack_ready_time.melee
			node.knockback_force = attack_knockback.melee
			node.damage = attack_damage.melee
	if "range" in attack_ready_time:
		range_attack_range.shape.radius = attack_range.range
		range_attack_timer.wait_time = attack_ready_time.range
	
	navigation_agent.target_desired_distance = \
		melee_attack_range.shape.radius - compute_collision_shape_use_size()

func _process(_delta):
	if is_dead || is_spawn: return
	update_state()
	update_animation()

func _physics_process(delta: float) -> void:
	if is_dead || is_spawn: return
	if navigation_agent.is_navigation_finished(): return
	var axis = to_local(navigation_agent.get_next_path_position()).normalized()
	var intended_velocity = axis * current_move_speed
	navigation_agent.velocity = intended_velocity

func dead_handle():
	state_chart.send_event("dead")

func hurt_handle():
	state_chart.send_event("hurt")


func read_data():
	if !data_name: return
	var data = Global.enemy_data.get(data_name)
	var find_and_definition = func f(v: String, ps: Array) -> Dictionary:
		var rv: Dictionary = {}
		for p: String in ps:
			if p in data: rv.merge({p: data.get(p).get(v)})
		return rv
	attack_range = find_and_definition.call("attack_range", ["melee", "range"])
	attack_ready_time = find_and_definition.call("ready_time", ["collision", "melee", "range"])
	attack_knockback = find_and_definition.call("knockback_force", ["collision", "melee"])
	attack_damage = find_and_definition.call("damage", ["collision", "melee"])
	move_speed = data.move_speed_multiple * Common.move_speed
	max_health = data.max_health
	aggro_range.shape.radius = data.aggro_range
	de_aggro_range.shape.radius = data.de_aggro_range
	
	if "range" in data:
		var path = data.range
		projectile = load(FileFunction.get_file_list(Global.AMMO_DIRECTORY).get(path.projectile))
		projectile_speed = path.projectile_speed
		max_range_attack_distance = path.max_range_attack_distance
		min_range_attack_distance = path.min_range_attack_distance
	
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
	can_attack = (can_melee || can_range)
	is_attack = (is_melee || is_range)
	if !attack_target && !is_idle:
		state_chart.send_event("idle")
	else:
		if can_attack && !is_attack && melee_attack_timer.is_stopped():
			state_chart.send_event("attack")
		elif attack_target && !can_attack && !is_attack && !is_chase:
			state_chart.send_event("chase")
#更新状态

func update_animation():
	if attack_target:
		var m = (global_position - attack_target.position).normalized()
		if m.x > 0:
			body_texture.flip_h = true
		else:
			body_texture.flip_h = false
	if is_attack:
		aimline_rotation()
		if !melee_attack_hitboxs.get_children().is_empty():
			melee_attack_hitboxs_rotation()
#纹理朝向和渲染索引

func recalc_path():
	if !attack_target && !aggro_target.is_empty():
		var min: float = -1
		for target in aggro_target:
			if min == -1 || min > (target.global_position - global_position).length():
				attack_target = target
	if attack_target:
		if (max_range_attack_distance == 0 && min_range_attack_distance == 0):
			get_path_to_target()
		else:
			if (attack_target.global_position - global_position).length() > max_range_attack_distance:
				can_range = false
				get_path_to_target()
			elif (attack_target.global_position - global_position).length() < min_range_attack_distance:
				can_range = false
				get_path_to_away_target()
			else:
				can_range = true
	else:
		navigation_agent.target_position = position

func get_path_to_target():
	navigation_agent.target_position = attack_target.global_position

func get_path_to_away_target():
	var dir: Vector2 = (global_position - attack_target.position).normalized()
	navigation_agent.target_position = attack_target.global_position\
			+ dir * (min_range_attack_distance + compute_collision_shape_use_size())

func shoot():
	var ammo = projectile.instantiate()
	ammo.launch(
		global_position,
		(attack_target.global_position - global_position).normalized(),
		projectile_speed
		)
	get_tree().current_scene.add_child(ammo)

func compute_collision_shape_use_size() -> float:
	var v
	match body_collision.shape.get_class():
		"CircleShape2D":
			v = body_collision.shape.radius * 2
		"RectangleShape2D":
			if body_collision.shape.size.x < body_collision.shape.size.y:
				v = body_collision.shape.size.x
			else:
				v = body_collision.shape.size.y
	return v as float if !(v is float) else v

func aimline_rotation():
	var tg = attack_target.global_position
	var g = global_position
	var tr: Vector2 = (tg - g).normalized()
	aim_line.rotation = tr.angle()

func melee_attack_hitboxs_rotation():
	var tg = attack_target.global_position
	var g = global_position
	var tr: Vector2 = (tg - g).normalized()
	melee_attack_hitboxs.rotation = tr.angle()


func _on_path_timer_timeout():
	recalc_path()


func _on_melee_attack_range_area_entered(area: PlayerHurtbox) -> void:
	can_melee = true


func _on_melee_attack_range_area_exited(area: PlayerHurtbox) -> void:
	can_melee = false


func _on_range_attack_range_area_entered(area: PlayerHurtbox) -> void:
	can_range = true


func _on_range_attack_range_area_exited(area: PlayerHurtbox) -> void:
	can_range = false


func _on_aggro_range_area_entered(area):
	aggro_target.append(area.owner)


func _on_de_aggro_range_area_exited(area):
	if area.owner in aggro_target:
		aggro_target.erase(area.owner)
		if attack_target == area.owner:
			attack_target = null


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
