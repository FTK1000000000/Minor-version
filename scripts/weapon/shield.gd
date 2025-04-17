extends Weapon


@onready var resistbox: Resistbox = $Resistbox


func special_attack():
	resist()


func resist():
	if (
		Input.is_action_just_pressed("attack_special") &&
		player.current_endurance >= special_attack_consume_endurance
		):
			player.current_endurance -= special_attack_consume_endurance
			#hitbox.damage = resist_damage
			player.is_resist = true
			player.is_endurance_disable = true
			is_special_charge = true
			animation_player.play("resist")
			perfect_parry_time()
	
	elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		#hitbox.damage = old_hit_damage
		player.is_resist = false
		player.is_endurance_disable = false
		is_special_charge = false
		animation_player.play("recover")
		perfect_parry_time()
	
	elif Input.is_action_just_released("attack_special") && current_charge <= need_charge:
		#hitbox.damage = old_hit_damage
		player.is_resist = false
		player.is_endurance_disable = false
		is_special_charge = false
		animation_player.play("recover")
		perfect_parry_time()

func perfect_parry_time() -> void:
	resistbox.perfect_parry_timer.start()
