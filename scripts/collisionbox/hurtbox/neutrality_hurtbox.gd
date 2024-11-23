extends EnemyHurtbox


func take_damage(damage: int, direction: Vector2, force: int):
	super(damage, direction, force)
	parent.is_enemy = true
	parent.hitbox.monitoring = true
