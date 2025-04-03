extends Enemy


func melee_animaction():
	state_tween = create_tween()
	state_tween.tween_property(self, "global_position", attack_position, 0.6)


func _on_melee_state_entered() -> void:
	super()
	if melee_attack_timer.is_stopped():
		attack_position = attack_target.global_position
		current_move_speed = 0
		state_player.play("melee")
		await state_player.animation_finished
		
		melee_attack_timer.start()
		state_chart.send_event("idle")
