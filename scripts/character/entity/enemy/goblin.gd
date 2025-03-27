extends Enemy


func melee_animaction():
	state_tween = create_tween()
	state_tween.tween_property(self, "global_position", target_position, 0.6)


func _on_melee_state_entered() -> void:
	if !is_melee:
		is_melee = true
	
	if is_melee_area_rotation:
		melee_area_rotation()
	aimline_rotation()
	
	if attack_is_ready:
		current_move_speed = 0
		target_position = attack_target.global_position
		
		state_player.play("melee")
		await state_player.animation_finished
		
		attack_is_ready = false
		
		if attack_timer.is_stopped():
			attack_timer.start()
			await attack_timer.timeout
			
			attack_is_ready = true
		state_chart.send_event("idle")
