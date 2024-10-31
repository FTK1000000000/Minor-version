extends Enemy


const AMMO = preload("res://ammo/ammo.tscn")

@export var max_distance_to_player: int = 160
@export var min_distance_to_player: int = 128
@export var distance_to_player: float

@export var projectile_speed: int = 200


func _ready():
	super()
	var v = 10
	navigation_agent.target_desired_distance = v

func update_state():
	if is_dead:
		state_chart.send_event("dead")
		is_dead = false
	
	if !aggro_target:
		state_chart.send_event("idle")
	
	elif aggro_target:
		if attack_target && is_can_attack:
			state_chart.send_event("attack")
		elif attack_is_ready:
			state_chart.send_event("chase")

func recalc_path():
	if aggro_target:
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
	navigation_agent.target_position = aggro_target.global_position + dir * min_distance_to_player

func shoot():
	var projectile = AMMO.instantiate()
	
	projectile.launch(global_position, (target_position - global_position).normalized(), projectile_speed)
	get_tree().current_scene.add_child(projectile)


func _on_idle_state_entered() -> void:
	animation_player.play("RESET")


func _on_chase_state_entered() -> void:
	#animation_player.play("walk")
	pass


func _on_ranged_state_entered() -> void:
	aimline_rotation()
	
	if attack_is_ready:
		current_move_speed = 0
		target_position = attack_target.global_position
		
		animation_player.play("ranged")
		await animation_player.animation_finished
		
		attack_is_ready = false
		if attack_timer.is_stopped():
			attack_timer.start()
			await attack_timer.timeout
			
			attack_is_ready = true
		current_move_speed = move_speed
