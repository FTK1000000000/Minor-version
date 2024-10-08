extends Area2D
class_name Hurtbox


@onready var parent = get_node("..")


func take_damage(damage: int, direction: Vector2, force: int):
	if parent is Player:
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
	
	elif parent is StaticBody2D:
		parent.current_health -= damage
	
	else:
		parent.current_health -= damage
		parent.velocity += direction * force
		parent.state_chart.send_event("hurt")
	
