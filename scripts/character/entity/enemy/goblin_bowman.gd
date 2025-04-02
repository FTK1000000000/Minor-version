extends Enemy


var projectile = preload("res://ammo/arrow/goblin_arrow.tscn")
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
		if attack_target && can_range:
			state_chart.send_event("range")
		#elif attack_ready:
			state_chart.send_event("chase")
		else:
			current_move_speed = 0

func recalc_path():
	if aggro_target && !is_attack:
		distance_to_player = (attack_target.position - global_position).length()
		if distance_to_player > max_distance_to_player:
			can_range = false
			get_path_to_target()
		elif distance_to_player < min_distance_to_player:
			can_range = false
			get_path_to_move_away_from_player()
		else:
			can_range = true
#寻路

func get_path_to_move_away_from_player():
	var dir: Vector2 = (global_position - attack_target.position).normalized()
	var v = attack_target.global_position + dir * (min_distance_to_player + compute_collision_shape_use_size())
	navigation_agent.target_position = v

func shoot():
	projectile.instantiate().launch(
		global_position,
		(attack_target.global_position - global_position).normalized(),
		projectile_speed
		)
	get_tree().current_scene.add_child(projectile.instantiate())


#func _on_ranged_state_entered() -> void:
	#aimline_rotation()
	#
	#if attack_ready:
		#attack_position = attack_target.global_position
		#current_move_speed = 0
		#attack_target.position = attack_target.global_position
		#is_range = true
		#
		#state_player.play("ranged")
		#await state_player.animation_finished
		#
		#attack_ready = false
		#if range_attack_timer.is_stopped():
			#range_attack_timer.start()
			#await range_attack_timer.timeout
			#
			#attack_ready = true
		#current_move_speed = move_speed
		#is_range = false
		#state_chart.send_event("idle")
