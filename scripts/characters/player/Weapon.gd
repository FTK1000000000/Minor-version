extends Node2D


@onready var player: Player = $".."
@onready var weapon: Node2D = self.get_child(0)


func weapon_transform(
	gm = get_global_mouse_position(),
	 lm = get_local_mouse_position(),
	 g = global_position
	):
		var mouse_direction: Vector2 = (gm - g).normalized()
		weapon.rotation = mouse_direction.angle()
		
		if lm.y > 0:
			weapon.z_index = 1
		else:
			weapon.z_index = 0
		
		if player.weapon_flip:
			weapon.scale.y = -1
		else:
			weapon.scale.y = 1
		
		if player.is_flip && weapon is Shield:
			weapon.textruse.frame = 1
		elif !player.is_flip && weapon is Shield:
			weapon.textruse.frame = 0
			

func weapon_attack():
	if (
		!player.is_weapon_attack &&
		player.current_endurance >= weapon.attack_consume_endurance &&
		weapon.attack_ready_timer.is_stopped()
		):
			if weapon is Shield && player.is_flip:
				weapon.animation_player.play("attack_flip")
			else:
				weapon.animation_player.play("attack")
			
			weapon.attack_ready_timer.start()
			player.current_endurance -= weapon.attack_consume_endurance
			player.endurance_changed.emit()
			player.is_weapon_attack = true
			player.is_endurance_disable = true
			await weapon.attack_ready_timer.timeout
			
			if weapon is Shield && player.is_flip:
				weapon.animation_player.play("RESET_flip")
			else:
				weapon.animation_player.play("RESET")
			
			if !player.is_walk:
				player.is_endurance_disable = false
			player.is_weapon_attack = false

func weapon_special_attack():
	weapon.special_attack()
