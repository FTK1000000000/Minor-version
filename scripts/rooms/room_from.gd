extends Node2D


const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://characters/enemy/spawn_expansion.tscn")

@onready var door_container: Node2D = get_node("Doors")
@onready var player_detector: Area2D = get_node("PlayerDetector")


func open_doors():
	for door in door_container.get_children():
		door.open()

func _on_player_detector_body_entered(_body: CharacterBody2D) -> void:
	player_detector.queue_free()
	open_doors()
