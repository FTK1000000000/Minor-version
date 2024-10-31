extends Boss


func _on_idle_state_entered() -> void:
	animation_player.play("RESET")


func _on_chase_state_entered() -> void:
	animation_player.play("walk")
