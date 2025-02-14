extends Hurtbox
class_name EnemyHurtbox


func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	if owner.is_dead: return
	if damage < target.current_health:
		target.set_current_health(target.current_health - damage)
		target.velocity += direction * force
		target.popup_location.popup(damage, direction)
		target.hud.show()
		target.hurting.emit()
		
		bleed(damage, direction, force)
		mark(damage, direction, force)
		jitter(damage, direction, force)
	else:
		target.deading.emit()
		
		explode(damage, direction, force)
