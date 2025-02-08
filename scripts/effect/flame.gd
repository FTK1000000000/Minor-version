extends Effect


func effect():
	super()
	var hurtbox: Hurtbox = target.hurtbox
	hurtbox.take_damage("fire", 5)
