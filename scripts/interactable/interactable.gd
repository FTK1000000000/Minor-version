extends Area2D
class_name Interactable

signal interacted


func _init() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(3, true)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func interaction():
	interacted.emit()
	print("interaction to ", name)


func _on_body_entered(player: Player) -> void:
	player.interactable_with = self


func _on_body_exited(player: Player) -> void:
	player.interactable_with = null
