extends Area2D


@export_file() var path


func _on_body_entered(_body: Player) -> void:
	Global.go_to_world(path)
