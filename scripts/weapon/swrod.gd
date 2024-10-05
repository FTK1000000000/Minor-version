extends Weapon
class_name Swrod


@export var max_charge: int = 10
@export var need_charge: int = 3
@export var current_charge: int = 0


func special_attack():
	windmill()


func windmill():
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

func charge_timer():
	if charge_attack_ready_timer.time_left == 0: 
		charge_attack_ready_timer.start()
		await charge_attack_ready_timer.timeout
		
		if current_charge >= max_charge || !Input.is_action_pressed("attack_special"):
			return
		current_charge += 1
		print(current_charge)
		charge_timer()
