extends Hurtbox


func take_damage(damage: int, direction: Vector2, force: int):
	if GlobalPlayerState.sturdy_shield:
		damage = damage * 0.75 as int
		
		if parent.is_resist && parent.current_endurance >= damage:
			parent.current_endurance -= damage
			parent.velocity += direction * force
			parent.weapon_node.weapon.effect_player.play("resist")
			parent.endurance_changed.emit()
			parent.is_endurance_disable = true
		
		elif parent.current_endurance < damage:
			parent.current_health -= (damage - parent.current_endurance)
			parent.velocity += direction * force
			parent.state_chart.send_event("hurt")
			parent.is_endurance_disable = true
	
	else:
		parent.current_health -= damage
		parent.velocity += direction * force
		parent.state_chart.send_event("hurt")
		parent.is_endurance_disable = true
		
		Global.animation_player.play("player_hurt")
		bleed(damage, direction, force)
		mark(damage, direction, force)
	
	parent.camera.camera_should_shake(2)
	
	Engine.time_scale = 0.01
	await get_tree().create_timer(0.03, true, false, true).timeout
	Engine.time_scale = 1
