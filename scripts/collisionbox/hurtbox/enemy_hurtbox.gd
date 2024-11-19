extends Hurtbox
class_name EnemyHurtbox


func take_damage(damage: int, direction: Vector2, force: int):
	parent.current_health -= damage
	parent.velocity += direction * force
	parent.state_chart.send_event("hurt")
	
	bleed(damage, direction, force)
	mark(damage, direction, force)
	jitter(damage, direction, force)
