extends Area2D


@export_file() var path


func _on_body_entered(_body: Player) -> void:
	if path:
		Global.room_group_level += 1
		Global.load_world(path)
	else:
		Global.complete_game()
