extends NavigationObstacle2D

const FROM_ROOMS: Array = [
	preload("res://rooms/room_from_0.tscn"),
	preload("res://rooms/room_from_1.tscn")
]
const INTERMEDIATE_ROOMS: Array = [
	preload("res://rooms/room_0.tscn"),
	preload("res://rooms/room_1.tscn")
]
const  END_ROOMS: Array = [
	preload("res://rooms/room_end.tscn")
]

const TILE_SIZE: int = 32
const FLOOR_TILE_INDEX: Vector2i = Vector2i(0, 0)
const RIGHT_WALL_TILE_INDEX: Vector2i = Vector2i(1, 0)
const LEFT_WALL_TILE_INDEX: Vector2i = Vector2i(1, 0)
#图块于图块集的坐标

@export var num_levels: int = 5

@onready var player: CharacterBody2D = get_node("../player")


func _ready() -> void:
	spawn_rooms()


func spawn_rooms():
	var previous_room: Node2D
	
	for i in num_levels:
		var room: Node2D
		var room_class: int
		
		if i == 0:
			room_class = 0
			room = FROM_ROOMS[randi() % FROM_ROOMS.size()].instantiate()
			player.position = room.get_node("PlayerSpawnPos").position
		else:
			if i == num_levels - 1:
				room_class = 2
				room = END_ROOMS[randi() % END_ROOMS.size()].instantiate()
			else:
				room_class = 1
				room = INTERMEDIATE_ROOMS[randi() % INTERMEDIATE_ROOMS.size()].instantiate()
				
			var previous_room_tilemap: Node2D = previous_room.get_node("TileMap")
			var previous_room_door: StaticBody2D = previous_room.get_node("Doors/Door")
			var exit_tile_position: Vector2i = previous_room_tilemap.get_node("Floor").local_to_map(previous_room_door.position) + Vector2i.UP * 2
			
			var corridor_height: int = randi() % 5 + 2
			
			for y in corridor_height:
				previous_room_tilemap.get_node("Wall").set_cell(exit_tile_position + Vector2i(-2, -y), 0, LEFT_WALL_TILE_INDEX)
				previous_room_tilemap.get_node("Floor").set_cell(exit_tile_position + Vector2i(-1, -y), 0, FLOOR_TILE_INDEX)
				previous_room_tilemap.get_node("Floor").set_cell(exit_tile_position + Vector2i(0, -y), 0, FLOOR_TILE_INDEX)
				previous_room_tilemap.get_node("Wall").set_cell(exit_tile_position + Vector2i(1, -y), 0, RIGHT_WALL_TILE_INDEX)
				
			var room_tilemap: TileMapLayer = room.get_node("TileMap/Floor")
			var entrance: Marker2D = room.get_node("Entrance/Marker2D2")
			
			if room_class == 2:
				room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * TILE_SIZE / 2  + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(entrance.position).x * TILE_SIZE + Vector2.LEFT * TILE_SIZE / 2 + Vector2.UP * 2 * TILE_SIZE
			else:
				room.position = previous_room_door.global_position + Vector2.UP * room_tilemap.get_used_rect().size.y * TILE_SIZE + Vector2.UP * TILE_SIZE / 2  + Vector2.UP * (1 + corridor_height) * TILE_SIZE + Vector2.LEFT * room_tilemap.local_to_map(entrance.position).x * TILE_SIZE + Vector2.LEFT * TILE_SIZE / 2
			 
			
		add_child(room)
		previous_room = room
