extends PlayerHurtbox


func take_damage(damage: int, direction: Vector2, force: int):
	if damage < parent.current_health:
		#the skill for tank
		#parent.velocity += (direction * force)
		
		parent.current_health -= damage
		parent.is_endurance_disable = true
		parent.hurt.emit()
		
		Global.animation_player.play("player_hurt")
		bleed(damage, direction, force)
		mark(damage, direction, force)
	else:
		parent.current_health = 0
		parent.velocity += direction * force
		parent.hurt.emit()
		parent.dead.emit()
		
		explode(damage, direction, force)
	
	parent.camera.camera_should_shake(damage / 10)
	Engine.time_scale = 0.01
	await get_tree().create_timer(0.03, true, false, true).timeout
	
	Engine.time_scale = 1
