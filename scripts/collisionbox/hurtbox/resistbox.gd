extends Hurtbox
class_name Resistbox


func take_damage(damage: int, direction: Vector2, force: int):
	var player = GlobalPlayerState.player
	damage = damage * 0.75 as int
	
	print(player.current_endurance)
	if player.current_endurance >= damage:
		player.current_endurance -= damage
		player.velocity += direction * force
		player.weapon_node.weapon.effect_player.play("resist")
		player.endurance_changed.emit()
		player.is_endurance_disable = true
	
	else:
		player.current_health -= (damage - player.current_endurance)
		player.current_endurance -= player.current_endurance
		player.velocity += direction * force
		player.state_chart.send_event("hurt")
		player.is_endurance_disable = true
		
		bleed(damage, direction, force)
		mark(damage, direction, force)
	
	player.camera.camera_should_shake(2)
	
	Engine.time_scale = 0.01
	await get_tree().create_timer(0.03, true, false, true).timeout
	Engine.time_scale = 1
