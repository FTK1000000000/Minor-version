extends Hurtbox
class_name Resistbox


func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	var player = GlobalPlayerState.player
	damage = damage * 0.75 as int
	
	print(player.current_endurance)
	if GlobalPlayerState.player_current_endurance >= damage:
		GlobalPlayerState.player_current_endurance -= damage
		player.velocity += direction * force
		player.weapon_node.weapon.effect_player.play("resist")
		GlobalPlayerState.endurance_changed.emit()
		player.is_endurance_disable = true
	
	else:
		GlobalPlayerState.player_current_endurance -= (damage - GlobalPlayerState.player_current_endurance)
		GlobalPlayerState.player_current_endurance -= GlobalPlayerState.player_current_endurance
		player.velocity += direction * force
		player.state_chart.send_event("hurt")
		player.is_endurance_disable = true
		
		bleed(damage, direction, force)
		mark(damage, direction, force)
	
	player.camera.camera_should_shake(2)
	
	Engine.time_scale = 0.01
	await get_tree().create_timer(0.03, true, false, true).timeout
	Engine.time_scale = 1
