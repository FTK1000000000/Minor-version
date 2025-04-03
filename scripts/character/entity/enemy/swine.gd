extends Enemy


func update_state():
	if !attack_target && !is_idle:
		state_chart.send_event("idle")
	elif attack_target && !is_chase:
		state_chart.send_event("chase")


func _on_hurt_state_entered() -> void:
	if !is_hurt:
		is_hurt = true
	health_changed.emit()
	state_player.play("hurt")
	hurt_effect_player.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	hurt_effect_player.play("RESET")
	if state_tween:
		state_tween.kill()
