extends PlayerHurtbox


func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	if damage < target.current_health:
		#the skill for tank
		#target.velocity += (direction * force)
		
		target.set_current_health(target.current_health - damage)
		target.is_endurance_disable = true
		target.hurting.emit()
		
		Global.animation_player.play("player_hurt")
		bleed(damage, direction, force)
		mark(damage, direction, force)
	else:
		target.set_current_health(0)
		target.velocity += direction * force
		target.hurting.emit()
		target.deading.emit()
		
		explode(damage, direction, force)
	
	target.camera.camera_should_shake(damage / 10)
	Engine.time_scale = 0.01
	await get_tree().create_timer(0.03, true, false, true).timeout
	
	Engine.time_scale = 1
