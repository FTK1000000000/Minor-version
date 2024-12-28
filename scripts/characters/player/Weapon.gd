extends Node2D


@onready var player: Player = $".."

@export var weapon: Weapon


func _ready() -> void:
	GlobalPlayerState.weapon_update.connect(weapon_get)


func weapon_get():
	weapon = self.get_child(0)

func weapon_transform(
	gm = get_global_mouse_position(),
	 lm = get_local_mouse_position(),
	 g = global_position
	):
		if !weapon:
			return
		
		var mouse_direction: Vector2 = (gm - g).normalized()
		weapon.rotation = mouse_direction.angle()
		
		if lm.y > 0:
			weapon.z_index = 1
		else:
			weapon.z_index = 0
		
		if player.is_weapon_flip:
			weapon.scale.y = -1
		else:
			weapon.scale.y = 1
		
		if player.is_flip && weapon is Shield:
			weapon.textruse.frame = 1
		elif !player.is_flip && weapon is Shield:
			weapon.textruse.frame = 0
			

func weapon_attack():
	if !weapon:
		return
	
	if (
		!player.is_weapon_attack &&
		player.current_endurance >= weapon.attack_consume_endurance &&
		weapon.attack_ready_timer.is_stopped() &&
		!Input.is_action_pressed("selected_card_slot")
		):
			if GlobalPlayerState.weapon_attack_twice:
				weapon.animation_player.play("attack")
				weapon.attack_ready_timer.start()
				player.current_endurance -= weapon.attack_consume_endurance
				GlobalPlayerState.player_current_endurance = player.current_endurance
				GlobalPlayerState.endurance_changed.emit()
				player.is_weapon_attack = true
				player.is_endurance_disable = true
				await weapon.attack_ready_timer.timeout
				
				weapon.animation_player.play("RESET")
				weapon.animation_player.play("attack")
				weapon.attack_ready_timer.start()
				player.is_weapon_attack = true
				player.is_endurance_disable = true
				await weapon.attack_ready_timer.timeout
				
				weapon.animation_player.play("RESET")
				if !player.is_walk:
					player.is_endurance_disable = false
				player.is_weapon_attack = false
			
			else:
				if weapon is Shield && player.is_flip:
					weapon.animation_player.play("attack_flip")
				else:
					weapon.animation_player.play("attack")
				
				weapon.attack_ready_timer.start()
				player.current_endurance -= weapon.attack_consume_endurance
				GlobalPlayerState.player_current_endurance = player.current_endurance
				GlobalPlayerState.endurance_changed.emit()
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
	if !weapon:
		return
	
	weapon.special_attack()
