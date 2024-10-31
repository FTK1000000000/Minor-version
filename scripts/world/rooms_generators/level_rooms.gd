extends Node2D


const LEVEL_0: Array = [
	preload("res://rooms/room_groups/room_group_0.tscn"),
]
const LEVEL_1: Array = [
	preload("res://rooms/room_groups/room_group_0.tscn"),
]
const LEVEL_2: Array = [
	#preload("res://rooms/room_groups/room_group_1.tscn")
	preload("res://rooms/boss_rooms/boss_room.tscn")
]


var storey_level: int = Global.storey_level
var room_index: int = Global.room_index

@onready var player: Player = $"../Player"


func _ready() -> void:
	spawn_rooms()


func spawn_rooms():
	var room
	var player_spawn_position
	
	match storey_level:
		0:
			room = LEVEL_0[randi() % LEVEL_0.size()].instantiate()
		1:
			room = LEVEL_1[randi() % LEVEL_1.size()].instantiate()
		2:
			room = LEVEL_2[randi() % LEVEL_2.size()].instantiate()
		3:
			Global.load_world("res://ui/game_complete.tscn")
			
			return
	
	add_child(room)
	
	if room is BossRoom:
		player_spawn_position = room.player_spawn.position
	else:
		player_spawn_position = room.from_room.player_spawn_position
	player.position = player_spawn_position
