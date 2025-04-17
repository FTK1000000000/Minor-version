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
		if !weapon: return
		
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
		
		if GlobalPlayerState.weapon.data_name == "shield":
			if player.is_flip:
				weapon.main.frame = 1
			else:
				weapon.main.frame = 0
			

func weapon_attack():
	if !weapon: return
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
				GlobalPlayerState.current_endurance = player.current_endurance
				GlobalPlayerState.endurance_changed.emit()
				await weapon.attack_ready_timer.timeout
				
				weapon.animation_player.play("RESET")
				weapon.animation_player.play("attack")
				weapon.attack_ready_timer.start()
				if weapon.animation_player.is_playing():
					await weapon.animation_player.animation_finished
				else:
					await weapon.attack_ready_timer.timeout
				
				weapon.animation_player.play("RESET")
				player.state_chart.send_event("idle")
			else:
				if GlobalPlayerState.weapon.data_name == "shield" && player.is_flip:
					weapon.animation_player.play("attack_flip")
				else:
					weapon.animation_player.play("attack")
				
				weapon.attack_ready_timer.start()
				player.current_endurance -= weapon.attack_consume_endurance
				GlobalPlayerState.current_endurance = player.current_endurance
				GlobalPlayerState.endurance_changed.emit()
				
				if weapon.animation_player.is_playing():
					await weapon.animation_player.animation_finished
				else:
					await weapon.attack_ready_timer.timeout
				
				if GlobalPlayerState.weapon.data_name == "shield" && player.is_flip:
					weapon.animation_player.play("RESET_flip")
				else:
					weapon.animation_player.play("RESET")
				player.state_chart.send_event("idle")

func weapon_special_attack():
	if !weapon: return
	
	weapon.special_attack()
