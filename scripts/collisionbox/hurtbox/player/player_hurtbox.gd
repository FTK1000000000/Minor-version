extends Hurtbox
class_name PlayerHurtbox


func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	if damage < parent.current_health:
		parent.velocity += (direction * force)
		parent.current_health -= damage
		parent.is_endurance_disable = true
		parent.hurting.emit()
		
		Global.animation_player.play("player_hurt")
		bleed(damage, direction, force)
		mark(damage, direction, force)
		ready_time()
	else:
		parent.deading.emit()
		
		explode(damage, direction, force)
	
	parent.camera.camera_should_shake(damage / 10)
	Engine.time_scale = 0.01
	await get_tree().create_timer(0.03, true, false, true).timeout
	
	Engine.time_scale = 1
