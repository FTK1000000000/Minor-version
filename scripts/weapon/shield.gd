extends Weapon
class_name Shield


@export var resist_damage: int = 5
var old_hit_damage = hit_damage


func special_attack():
	resist()


func resist():
	if (
		Input.is_action_just_pressed("attack_special") &&
		player.current_endurance >= special_attack_consume_endurance
		):
			player.current_endurance -= special_attack_consume_endurance
			if Input.is_action_pressed("attack_special"):
				hit_damage = resist_damage
				animation_player.play("resist")
	
	elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		hit_damage = old_hit_damage
		animation_player.play("recover")
	
	elif Input.is_action_just_released("attack_special") && current_charge <= need_charge:
		hit_damage = old_hit_damage
		animation_player.play("recover")
