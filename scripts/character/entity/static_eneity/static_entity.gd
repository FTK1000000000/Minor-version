extends Entity
class_name static_entity


func _on_idle_state_entered() -> void:
	is_idle = true


func _on_idle_state_exited() -> void:
	is_idle = false


func _on_hurt_state_entered() -> void:
	is_hurt = true
	hurt_effect_player.play("hurt_blinka")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	hurt_effect_player.play("RESET")
	state_chart.send_event("idle")


func _on_hurt_state_exited() -> void:
	is_hurt = false


func _on_dead_state_entered() -> void:
	if !is_dead:
		is_dead = true
		state_player.play("dead")
		await state_player.animation_finished
		
		queue_free()


func _on_dead_state_exited() -> void:
	is_dead = false
