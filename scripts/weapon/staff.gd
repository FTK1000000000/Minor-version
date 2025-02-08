extends Weapon
#class_name Swrod


@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

var ammo = preload("res://ammo/fire_ball.tscn")
#var ammo_fram: Array = [
	#"res://texture/ammo/sword_ammo_1.png",
	#"res://texture/ammo/sword_ammo_2.png",
	#"res://texture/ammo/sword_ammo_3.png"
#]
var ammo_frame_value: int = 1


func special_attack():
	#windmill()
	shoot()

func _process(delta: float) -> void:
	if !is_special_charge:
		return
	
	gpu_particles_2d.rotation = texture.rotation


#func windmill():
	#if (
		#Input.is_action_just_pressed("attack_special") &&
		#player.current_endurance >= special_attack_consume_endurance
		#):
			#player.current_endurance -= special_attack_consume_endurance
			#GlobalPlayerState.endurance_changed.emit()
			#player.is_endurance_disable = true
			#is_special_charge = true
			#animation_player.play("charge")
			#charge_timer()
	#
	#elif Input.is_action_pressed("attack_special") && current_charge >= max_charge:
		#charge_comlete()
	#
	#elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		#charge_comlete()
	#
	#elif Input.is_action_just_released("attack_special") && current_charge <= need_charge:
		#charge_comlete(false)

func shoot():
	if (
		Input.is_action_just_pressed("attack_special") &&
		GlobalPlayerState.player_current_endurance >= special_attack_consume_endurance
		):
			special_consume()
			animation_player.play("charge")
			charge_timer()
			gpu_particles_2d.emitting = true
	
	elif Input.is_action_pressed("attack_special") && current_charge >= max_charge:
		charge_comlete()
		launch()
		gpu_particles_2d.emitting = false
	
	elif Input.is_action_just_released("attack_special") && current_charge >= need_charge:
		charge_comlete()
		launch()
		gpu_particles_2d.emitting = false
	
	elif Input.is_action_just_released("attack_special") && current_charge < need_charge:
		charge_comlete()
		gpu_particles_2d.emitting = false

func launch():
	var projectile = ammo.instantiate()
	
	projectile.launch(
		global_position,
		(
			get_global_mouse_position() - global_position).normalized(),
			projectile_speed
		)
	get_tree().current_scene.add_child(projectile)
	
	#projectile.sprite_2d.texture = load(ammo_fram[ammo_frame_value - 1])
	##gpu_particles_2d.texture = load(ammo_fram[ammo_frame_value - 1])
	#ammo_frame_value += 1 if ammo_frame_value < 2 else -2

func a():
	get_tree().quit()
