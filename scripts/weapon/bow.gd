extends Weapon
class_name Bow


var ammo = preload("res://characters/ammo/arrow.tscn")
@export var arrow_speed: int = 400


func special_attack():
	shoot()


func shoot():
	if Input.is_action_pressed("attack_special"):
		if current_charge >= max_charge:
			current_charge = 0
			animation_player.play("charge_complete")
			launch()
		
		charge_timer()
		animation_player.play("charge")
	
	elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		current_charge = 0
		animation_player.play("charge_complete")
		launch()
	
	elif Input.is_action_just_released("attack_special") && current_charge <= need_charge:
		current_charge = 0
		animation_player.play("charge_complete")

func launch():
	var projectile = ammo.instantiate()
	
	projectile.launch(
		global_position,
		(get_global_mouse_position() - global_position).normalized(),
		arrow_speed
		)
	get_tree().current_scene.add_child(projectile)
