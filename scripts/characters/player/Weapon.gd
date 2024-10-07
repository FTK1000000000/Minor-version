extends Node2D


@onready var player: Player = $".."
@onready var weapon: Node2D = self.get_child(0)


func weapon_transform(
	gm = get_global_mouse_position(),
	 lm = get_local_mouse_position(),
	 g = global_position):
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

func weapon_attack():
	player.is_weapon_attack = true
	if (
		player.is_weapon_attack &&
		player.current_endurance >= weapon.attack_consume_endurance &&
		weapon.attack_ready_timer.time_left == 0
		):
			weapon.attack_ready_timer.start()
			weapon.animation_player.play("attack")
			player.current_endurance -= weapon.attack_consume_endurance
			player.endurance_changed.emit()
			player.is_endurance_consume = true
			await weapon.attack_ready_timer.timeout
			
			player.is_weapon_attack = false
			weapon.animation_player.play("RESET")

func weapon_special_attack():
	weapon.special_attack()
