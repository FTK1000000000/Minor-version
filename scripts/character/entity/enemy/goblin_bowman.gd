extends Enemy


func update_state():
	can_attack = (can_melee || can_range)
	is_attack = (is_melee || is_range)
	if !attack_target && !is_idle:
		state_chart.send_event("idle")
	else:
		if can_attack && !is_attack && range_attack_timer.is_stopped():
			state_chart.send_event("attack")
		elif attack_target && !can_attack && !is_attack && !is_chase:
			state_chart.send_event("chase")


func _on_ranged_state_entered() -> void:
	super()
	if range_attack_timer.is_stopped():
		attack_position = attack_target.global_position
		current_move_speed = 0
		state_player.play("ranged")
		await state_player.animation_finished
		
		range_attack_timer.start()
		state_chart.send_event("idle")
