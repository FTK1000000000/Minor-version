extends Node2D


const ROOM_GROUP = preload("res://rooms/room_groups/room_group_0.tscn")
const FROM_ROOMS: Array = [
	preload("res://rooms/from_rooms/from_room_0.tscn")
]
const FIGHT_ROOMS: Array = [
	preload("res://rooms/fight_rooms/fight_room_0.tscn")
]
const END_ROOMS: Array = [
	preload("res://rooms/end_rooms/end_room_0.tscn")
]

@onready var from_room_container: Node2D = $Rooms/FromRoom
@onready var end_room_container: Node2D = $Rooms/EndRoom
@onready var fight_room_container: Node2D = $Rooms/FightRoom
var room_number: int

@onready var player: Player = $"../Player"


func _ready() -> void:
	spawn_rooms()


func spawn_rooms():
	var room_group: Node2D = ROOM_GROUP.instantiate()
	add_child(room_group)
	
	var room_number_max: int
	
	room_number = randi() % 5
	room_number_max = room_number
	
	for from_room in room_number:
		var old_room_position: Vector2
		var room_position: Vector2
		
		if room_number == room_number_max:
			var room: Node2D = FROM_ROOMS[randi() % FROM_ROOMS.size()].instantiate()
			add_child(room)
			
			old_room_position = room.global_position
			room_number -= 1
		
		elif room_number > 1:
			var room: Node2D = FIGHT_ROOMS[randi() % FROM_ROOMS.size()].instantiate()
			add_child(room)
			
			room.position = old_room_position 
			room_number -= 1
		
		elif room_number == 1:
			var room: Node2D = END_ROOMS[randi() % FROM_ROOMS.size()].instantiate()
			add_child(room)
			room_number -= 1
	
	
	
	var player_spawn_position = room_group.from_room.player_spawn_position
	player.position = player_spawn_position
