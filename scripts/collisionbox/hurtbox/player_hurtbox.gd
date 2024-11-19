extends Hurtbox
class_name PlayerHurtbox


func take_damage(damage: int, direction: Vector2, force: int):
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
