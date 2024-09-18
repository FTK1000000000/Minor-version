extends Node2D


const FROM_ROOMS: Array = [
	preload("res://rooms/room_group_0.tscn")
]

@onready var player: Player = $"../Player"


func _ready() -> void:
	spawn_rooms()


func spawn_rooms():
	var room_group: Node2D
	room_group = FROM_ROOMS[randi() % FROM_ROOMS.size()].instantiate()
	
	add_child(room_group)
	
	var player_spawn_position = room_group.room_from.player_spawn_position
	player.position = player_spawn_position
