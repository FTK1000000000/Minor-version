extends Weapon
class_name Bow


var ammo = preload("res://ammo/arrow/arrow.tscn")
@export var arrow_speed: int = 400


func special_attack():
	shoot()


func shoot():
	if (
		Input.is_action_just_pressed("attack_special") &&
		player.current_endurance >= special_attack_consume_endurance
		):
			player.current_endurance -= special_attack_consume_endurance
			player.endurance_changed.emit()
			player.is_endurance_disable = true
			is_special_charge = true
			animation_player.play("charge")
			charge_timer()
	
	elif Input.is_action_pressed("attack_special") && current_charge >= max_charge:
		charge_comlete()
		launch()
	
	elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		charge_comlete()
		launch()
	
	elif Input.is_action_just_released("attack_special") && current_charge < need_charge:
		charge_comlete()
		launch()

func launch():
	var projectile = ammo.instantiate()
	
	projectile.launch(
		global_position,
		(get_global_mouse_position() - global_position).normalized(),
		arrow_speed
		)
	get_tree().current_scene.add_child(projectile)
