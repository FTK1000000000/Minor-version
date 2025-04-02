extends Enemy


func melee_animaction():
	var tv: Vector2
	var tp = attack_target.global_position
	var gp = global_position
	var ct = Common.tile_size / 2
	var cv = func(ba: float, bb: float):
		return ba if ba < bb + ct && ba > bb - ct else (
			bb + ct if ba - bb > 0 else bb - ct
			)
	tv = Vector2(cv.call(tp.x, gp.x), cv.call(tp.y, gp.y))
	
	state_tween = create_tween()
	state_tween.tween_property(self, "global_position", tv, 0.2)


func _on_melee_state_entered() -> void:
	super()
	melee_area_rotation()
	aimline_rotation()
	
	if melee_attack_timer.is_stopped():
		attack_position = attack_target.global_position
		current_move_speed = 0
		state_player.play("melee")
		await state_player.animation_finished
		
		melee_attack_timer.start()
		state_chart.send_event("idle")
