extends Enemy


var ammo = preload("res://ammo/arrow/goblin_arrow.tscn")
@export var projectile_speed: int = 200

@export var max_distance_to_player: int = 160
@export var min_distance_to_player: int = 128
@export var distance_to_player: float


func _ready():
	super()
	var v = 10
	navigation_agent.target_desired_distance = v

func update_state():
	#if is_dead:
		#state_chart.send_event("dead")
		#is_dead = false
	
	if !aggro_target:
		state_chart.send_event("idle")
	
	else:
		current_move_speed = move_speed
		if attack_target && is_can_attack:
			state_chart.send_event("attack")
		elif attack_is_ready:
			state_chart.send_event("chase")
		else:
			current_move_speed = 0

func recalc_path():
	if aggro_target && !is_attack:
		distance_to_player = (aggro_target.position - global_position).length()
		if distance_to_player > max_distance_to_player:
			is_can_attack = false
			get_path_to_player()
		elif distance_to_player < min_distance_to_player:
			is_can_attack = false
			get_path_to_move_away_from_player()
		else:
			is_can_attack = true
#寻路

func get_path_to_move_away_from_player():
	var dir: Vector2 = (global_position - aggro_target.position).normalized()
	var v = aggro_target.global_position + dir * (min_distance_to_player + collision_shape_2d.shape.radius * 2)
	navigation_agent.target_position = v

func shoot():
	var projectile = ammo.instantiate()
	
	projectile.launch(global_position, (target_position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)


func _on_ranged_state_entered() -> void:
	aimline_rotation()
	
	if attack_is_ready:
		current_move_speed = 0
		target_position = attack_target.global_position
		is_attack = true
		
		state_player.play("ranged")
		await state_player.animation_finished
		
		attack_is_ready = false
		if attack_timer.is_stopped():
			attack_timer.start()
			await attack_timer.timeout
			
			attack_is_ready = true
		current_move_speed = move_speed
		is_attack = false
		state_chart.send_event("idle")
