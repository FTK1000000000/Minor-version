extends Weapon
#class_name Bow


var ammo = preload("res://ammo/arrow/arrow.tscn")


func _ready() -> void:
	super()
	if GlobalPlayerState.rapid_fire:
		charge_attack_ready_timer.wait_time /= 2

func special_attack():
	shoot()


func shoot():
	if (
		Input.is_action_just_pressed("attack_special") &&
		GlobalPlayerState.player_current_endurance >= special_attack_consume_endurance
		):
			special_consume()
			animation_player.play("charge")
			charge_timer()
	
	elif Input.is_action_pressed("attack_special") && current_charge >= max_charge:
		charge_comlete()
		launch()
	
	elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		charge_comlete()
		launch()
	
	elif Input.is_action_just_released("attack_special") && current_charge < need_charge:
		charge_comlete(false)

func launch():
	var projectile = ammo.instantiate()
	
	projectile.launch(
		global_position,
		(get_global_mouse_position() - global_position).normalized(),
		projectile_speed
	)
	get_tree().current_scene.add_child(projectile)
