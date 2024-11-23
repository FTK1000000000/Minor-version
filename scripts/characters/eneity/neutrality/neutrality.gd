extends Enemy
class_name Neutral


@export var is_enemy: bool = false


func _ready() -> void:
	super()
	#read_data()
	#current_move_speed = move_speed
	#current_health = max_health
	#hitbox.damage = attack_damage
	#hitbox.knockback_force = attack_knockback_force
	#aim_line.size.x = attack_ranged_collision.shape.radius
	#attack_is_ready = true
	#
	#var v = attack_ranged_collision.shape.radius - body_collision.shape.radius * 2
	#navigation_agent.target_desired_distance = v
	#navigation_agent.path_desired_distance = 10
	
	hitbox.monitoring = false

func update_state():
	if is_dead:
		state_chart.send_event("dead")
		is_dead = false
	
	if !aggro_target || !is_enemy:
		state_chart.send_event("idle")
	
	elif is_enemy:
		if attack_target:
			state_chart.send_event("attack")
		elif attack_is_ready:
			state_chart.send_event("chase")

func recalc_path():
	if aggro_target && is_enemy:
		get_path_to_player()
	else:
		navigation_agent.target_position = position

func read_data():
	if !data_name:
		return
	
	var data = Global.neutrality_data.get(data_name)
	
	move_speed = data.move_speed
	max_health = data.max_health
	attack_damage = data.attack_damage
	attack_knockback_force = data.attack_knockback_force
	attack_ready_time = data.attack_ready_time
	attack_timer.wait_time = attack_ready_time
	print(data)
