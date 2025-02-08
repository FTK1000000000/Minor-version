extends EnemyHurtbox


func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	super(type, damage, direction, force)
	parent.is_enemy = true
	parent.hitbox.monitoring = true
	parent.trade.monitoring = false
	parent.trade.monitorable = false
