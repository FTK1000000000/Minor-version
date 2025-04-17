extends Hurtbox
class_name Resistbox


@onready var perfect_parry_timer: Timer = $PerfectParryTimer


func _ready() -> void:
	target = GlobalPlayerState.player


func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	#GlobalPlayerState.player.hurt_box.monitorable = false
	if !perfect_parry_timer.is_stopped():
		target.weapon_node.weapon.effect_player.play("perfect_parry")
	else:
		if target.current_endurance >= damage:
			target.set_current_endurance(target.current_endurance - damage)
			target.velocity += direction * force
			target.is_endurance_disable = true
			target.weapon_node.weapon.effect_player.play("resist")
		
		elif target.current_health >= damage:
			target.set_current_health(target.current_health - (damage - target.current_endurance))
			target.set_current_endurance(0)
			target.velocity += direction * force
			target.is_endurance_disable = true
			target.state_chart.send_event("hurt")
			
			bleed(damage, direction, force)
			mark(damage, direction, force)
		
		else:
			target.deading.emit()
		
		target.camera.camera_should_shake(2)
		Engine.time_scale = 0.01
		await get_tree().create_timer(0.03, true, false, true).timeout
		
		Engine.time_scale = 1


#func _on_perfect_parry_timer_timeout() -> void:
	#GlobalPlayerState.player.hurt_box.monitorable = true
