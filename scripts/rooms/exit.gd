extends Area2D


@export_file() var path


func _on_body_entered(_body: Player) -> void:
	if path:
		Global.go_to_world(path)
	else:
		Global.complete_game()
