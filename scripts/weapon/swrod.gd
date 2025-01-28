extends Weapon
#class_name Swrod


func special_attack():
	windmill()


func windmill():
	if (
		Input.is_action_just_pressed("attack_special") &&
		player.current_endurance >= special_attack_consume_endurance
		):
			player.current_endurance -= special_attack_consume_endurance
			GlobalPlayerState.endurance_changed.emit()
			player.is_endurance_disable = true
			is_special_charge = true
			animation_player.play("charge")
			charge_timer()
	
	elif Input.is_action_pressed("attack_special") && current_charge >= max_charge:
		charge_comlete()
	
	elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		charge_comlete()
	
	elif Input.is_action_just_released("attack_special") && current_charge <= need_charge:
		charge_comlete(false)
