extends Weapon
class_name Swrod


func special_attack():
	windmill()


func windmill():
	if (
		Input.is_action_just_pressed("attack_special") &&
		player.current_endurance >= special_attack_consume_endurance
		):
			player.current_endurance -= special_attack_consume_endurance
			if Input.is_action_pressed("attack_special"):
				if current_charge >= max_charge:
					current_charge = 0
					animation_player.play("charge_complete")
				
				charge_timer()
				animation_player.play("charge")
	
	elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		current_charge = 0
		animation_player.play("charge_complete")
	
	elif Input.is_action_just_released("attack_special") && current_charge <= need_charge:
		current_charge = 0
		animation_player.play("RESET")
