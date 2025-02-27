extends Player


var is_endurance_recover


func update_state():
	var is_still = velocity == Vector2.ZERO
	var shift: bool = false
	
	if Input.is_action_pressed("shift"):
		if shift:
			shift = false
		else:
			shift = true
	
	if !is_idle && is_still:
		state_chart.send_event("idle")
	
	#the skill for mage
	elif !is_still && !is_weapon_attack:
		if !is_walk && !shift:
			state_chart.send_event("walk")
		elif !is_endurance_recover && shift && current_endurance <= (GlobalPlayerState.max_endurance - 1):
			state_chart.send_event("endurance_recover")
	
	if (
		Input.is_action_just_pressed("attack") &&
		!Global.HUD.card_bar.is_show &&
		GlobalPlayerState.weapon.attack_ready_timer.is_stopped() &&
		current_endurance >= weapon_node.get_child(0).attack_consume_endurance
		):
		state_chart.send_event("weapon_attack")
	
	if Input.is_action_just_pressed("interaction") && interactable_with:
		interactable_with.back().interaction()

func headle_endurance():
	var idleing: bool = false
	if is_idle:
		await get_tree().create_timer(0.5).timeout
		
		if is_idle:
			idleing = true
	if (
		idleing &&
		!is_weapon_attack && 
		!is_weapon_special_charge_attack && 
		!is_resist &&
		current_endurance < GlobalPlayerState.max_endurance
		):
			is_endurance_disable = false
	
	if is_endurance_disable:
		end_recover_ready_timer.start()
	
	if current_endurance < 0:
		current_endurance = 0
	elif current_endurance > GlobalPlayerState.current_health:
		is_endurance_disable = true
	elif current_endurance < GlobalPlayerState.current_health && !is_endurance_disable:
		endurance_recover()

func endurance_recover():
	if (
		end_recover_ready_timer.is_stopped() &&
		endurance_recover_timer.is_stopped() &&
		!is_weapon_attack && 
		!is_weapon_special_charge_attack && 
		!is_resist
		):
			if current_endurance <= GlobalPlayerState.current_health - endurance_recover_amount:
				endurance_recover_timer.start()
				await endurance_recover_timer.timeout
				
				set_current_endurance(current_endurance + endurance_recover_amount)
				print("current_endurance: ", current_endurance)
				endurance_recover()
			elif current_endurance != GlobalPlayerState.current_health:
				set_current_endurance(GlobalPlayerState.current_health)
				print("current_endurance: ", current_endurance)


func endurance_recover_endurance_recover():
	if !is_endurance_recover && current_endurance > GlobalPlayerState.max_endurance:
		set_current_endurance(GlobalPlayerState.max_endurance)
		state_chart.send_event("walk")
		return
	elif is_endurance_recover && run_endurance_consume_timer.is_stopped():
		set_current_endurance(current_endurance + 1)
		is_endurance_disable = true
		run_endurance_consume_timer.start()
		await run_endurance_consume_timer.timeout
		
		endurance_recover_endurance_recover()


func _on_endurance_recover_state_entered() -> void:
	if !is_endurance_recover:
		is_endurance_recover = true
		print(name, " state: walk.endurance_recover")
	move_speed_multiple = GlobalPlayerState.run_move_speed_multiple / 2 / 2
	GlobalPlayerState.current_move_speed_multiple = move_speed_multiple
	animation_tree["parameters/TimeScale/scale"] = move_speed_multiple
	endurance_recover_endurance_recover()


func _on_endurance_recover_state_exited() -> void:
	is_endurance_recover = false
	move_speed_multiple = GlobalPlayerState.walk_move_speed_multiple
	GlobalPlayerState.current_move_speed_multiple = move_speed_multiple
	animation_tree["parameters/TimeScale/scale"] = move_speed_multiple
