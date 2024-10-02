extends Node2D


const LEVEL_0 = preload("res://rooms/home.tscn")
const LEVEL_1: Array = [
	preload("res://rooms/room_groups/room_group_0.tscn"),
]
const LEVEL_2: Array = [
	preload("res://rooms/room_groups/room_group_1.tscn")
]


var room_group_level: int = Global.room_group_level

@onready var player: Player = $"../Player"


func _ready() -> void:
	spawn_rooms()


func spawn_rooms():
	var room_group: Node2D
	
	match room_group_level:
		0:
			room_group = LEVEL_0.instantiate()
		1:
			room_group = LEVEL_1[randi() % LEVEL_1.size()].instantiate()
		2:
			room_group = LEVEL_2[randi() % LEVEL_2.size()].instantiate()
		3:
			Global.go_to_world("res://ui/game_complete.tscn")
			
			return
	
	add_child(room_group)
	
	var player_spawn_position = room_group.from_room.player_spawn_position
	player.position = player_spawn_position
