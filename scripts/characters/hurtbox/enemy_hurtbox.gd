extends Hurtbox


func take_damage(damage: int, direction: Vector2, force: int):
	
	bleed(damage, direction, force)
	mark(damage, direction, force)
	jitter(damage, direction, force)
