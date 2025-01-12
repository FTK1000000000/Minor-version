extends Player


var dodge_is_ready: bool = true


func update_state():
	super()
	
	#the skill for hunter
	if Input.is_action_just_pressed("dodge") && dodge_is_ready && current_endurance >= GlobalPlayerState.dodge_endurance_consume:
		state_chart.send_event("dodge")


func dodge_afterimage_spawn():
	var afterimage: Sprite2D = body_texture.duplicate()
	var life_time: float = 0.3
	afterimage.global_position = global_position
	get_parent().add_child(afterimage)
	create_tween().tween_property(afterimage, "modulate", Color(0, 0, 0, 0), life_time)
	await get_tree().create_timer(life_time).timeout
	
	afterimage.queue_free()


func _on_dodge_state_entered() -> void:
	print(name, " state: dodge")
	var dodge_direction: Vector2 = (direction if direction != Vector2.ZERO else old_direction)
	create_tween().tween_property(self, "velocity", (dodge_direction * GlobalPlayerState.dodge_length), GlobalPlayerState.dodge_time)
	set_current_endurance(current_endurance - GlobalPlayerState.dodge_endurance_consume)
	is_endurance_disable = true
	animation_tree.active = false
	dodge_is_ready = false
	animation_player.play("hunter/dodge")
	
	await animation_player.animation_finished
	animation_tree.active = true
	dodge_is_ready = true
