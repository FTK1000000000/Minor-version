extends EnemyHurtbox


func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	super(type, damage, direction, force)
	target.is_enemy = true
	target.hitbox.monitoring = true
	target.trade.monitoring = false
	target.trade.monitorable = false
