extends Hurtbox
class_name EnemyHurtbox


func take_damage(damage: int, direction: Vector2, force: int):
	if damage < parent.current_health:
		parent.current_health -= damage
		parent.velocity += direction * force
		parent.popup_location.popup(damage, direction)
		parent.hud.show()
		parent.hurting.emit()
		
		bleed(damage, direction, force)
		mark(damage, direction, force)
		jitter(damage, direction, force)
	else:
		parent.deading.emit()
		
		explode(damage, direction, force)
