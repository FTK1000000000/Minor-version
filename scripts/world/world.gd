extends Node2D


@onready var player = get_node("Player")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		Global.back_to_title()


func _on_inventory_closeed():
	get_tree().paused = false


func _on_inventory_opened():
	get_tree().paused = true
