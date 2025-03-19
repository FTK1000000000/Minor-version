extends Entity
class_name static_entity


@onready var popup_fragments: Node2D = $PopupFragments


func broken():
	for fragment in popup_fragments.get_children():
		var launch_tween = create_tween()
		var launch_position = Vector2(
			Global.rng.randi_range(-Common.tile_size, Common.tile_size),
			Global.rng.randi_range(-Common.tile_size, Common.tile_size)
		)
		launch_tween.tween_property(fragment, "position", launch_position, 0.5)
	
	#var popup_tween = create_tween()
	#var popup_height = randi_range(Common.TILE_SIZE / 4, Common.TILE_SIZE / 2)
	#popup_tween.tween_property(popup_fragments, "position:y", popup_height , 0.3)
	#
	#await popup_tween.finished
	#popup_tween.tween_property(popup_fragments, "position:y", -popup_height , 0.2)


func _on_idle_state_entered() -> void:
	is_idle = true


func _on_idle_state_exited() -> void:
	is_idle = false


func _on_hurt_state_entered() -> void:
	is_hurt = true
	hurt_effect_player.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	hurt_effect_player.play("RESET")
	state_chart.send_event("idle")


func _on_hurt_state_exited() -> void:
	is_hurt = false


func _on_dead_state_entered() -> void:
	if !is_dead:
		is_dead = true
		state_player.play("dead")
		await state_player.animation_finished
		
		queue_free()


func _on_dead_state_exited() -> void:
	is_dead = false
