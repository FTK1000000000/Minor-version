extends Enemy


func melee_animaction():
	create_tween().tween_property(self, "velocity", ((target_position - global_position).normalized() * current_move_speed), 0.6)


func _on_melee_state_entered() -> void:
	aimline_rotation()
	
	if attack_is_ready:
		current_move_speed = 0
		target_position = attack_target.global_position
		
		animation_player.play("melee")
		await animation_player.animation_finished
		
		attack_is_ready = false
		
		if attack_timer.is_stopped():
			attack_timer.start()
			await attack_timer.timeout
			
			attack_is_ready = true
		state_chart.send_event("idle")
