extends Node2D


const room_data = {
	"from": {
		"[(0, 1), (0, -1)]": [
			"res://rooms/t0,1;-0,-1.tscn"
		],
		"[(0, -1), (0, 1)]": [
			"res://rooms/t0,1;-0,-1.tscn"
		],
		"[(1, 0), (-1, 0)]": [
			"res://rooms/t1,0;-1,0.tscn",
		],
		"[(-1, 0), (1, 0)]": [
			"res://rooms/t1,0;-1,0.tscn",
		],
		"[(1, 0), (0, 1)]": [
			"res://rooms/t1,0;0,1.tscn",
		],
		"[(0, 1), (1, 0)]": [
			"res://rooms/t1,0;0,1.tscn",
		],
		"[(1, 0), (0, -1)]": [
			"res://rooms/t0,-1;1,0.tscn",
		],
		"[(0, -1), (1, 0)]": [
			"res://rooms/t0,-1;1,0.tscn",
		],
		"[(0, 1), (-1, 0)]": [
			"res://rooms/t-1,0;0,1.tscn",
		],
		"[(-1, 0), (0, 1)]": [
			"res://rooms/t-1,0;0,1.tscn"
		],
		"[(-1, 0), (0, -1)]": [
			"res://rooms/t0,-1;-1,0.tscn",
		],
		"[(0, -1), (-1, 0)]": [
			"res://rooms/t0,-1;-1,0.tscn",
		]
	},
	"fight": {
		"[(0, 1), (0, -1)]": [
			"res://rooms/t0,1;-0,-1.tscn"
		],
		"[(0, -1), (0, 1)]": [
			"res://rooms/t0,1;-0,-1.tscn"
		],
		"[(1, 0), (-1, 0)]": [
			"res://rooms/t1,0;-1,0.tscn",
		],
		"[(-1, 0), (1, 0)]": [
			"res://rooms/t1,0;-1,0.tscn",
		],
		"[(1, 0), (0, 1)]": [
			"res://rooms/t1,0;0,1.tscn",
		],
		"[(0, 1), (1, 0)]": [
			"res://rooms/t1,0;0,1.tscn",
		],
		"[(1, 0), (0, -1)]": [
			"res://rooms/t0,-1;1,0.tscn",
		],
		"[(0, -1), (1, 0)]": [
			"res://rooms/t0,-1;1,0.tscn",
		],
		"[(0, 1), (-1, 0)]": [
			"res://rooms/t-1,0;0,1.tscn",
		],
		"[(-1, 0), (0, 1)]": [
			"res://rooms/t-1,0;0,1.tscn"
		],
		"[(-1, 0), (0, -1)]": [
			"res://rooms/t0,-1;-1,0.tscn",
		],
		"[(0, -1), (-1, 0)]": [
			"res://rooms/t0,-1;-1,0.tscn",
		]
	},
	"end": {
		"[(0, 1), (0, -1)]": [
			"res://rooms/t0,1;-0,-1.tscn"
		],
		"[(0, -1), (0, 1)]": [
			"res://rooms/t0,1;-0,-1.tscn"
		],
		"[(1, 0), (-1, 0)]": [
			"res://rooms/t1,0;-1,0.tscn",
		],
		"[(-1, 0), (1, 0)]": [
			"res://rooms/t1,0;-1,0.tscn",
		],
		"[(1, 0), (0, 1)]": [
			"res://rooms/t1,0;0,1.tscn",
		],
		"[(0, 1), (1, 0)]": [
			"res://rooms/t1,0;0,1.tscn",
		],
		"[(1, 0), (0, -1)]": [
			"res://rooms/t0,-1;1,0.tscn",
		],
		"[(0, -1), (1, 0)]": [
			"res://rooms/t0,-1;1,0.tscn",
		],
		"[(0, 1), (-1, 0)]": [
			"res://rooms/t-1,0;0,1.tscn",
		],
		"[(-1, 0), (0, 1)]": [
			"res://rooms/t-1,0;0,1.tscn"
		],
		"[(-1, 0), (0, -1)]": [
			"res://rooms/t0,-1;-1,0.tscn",
		],
		"[(0, -1), (-1, 0)]": [
			"res://rooms/t0,-1;-1,0.tscn",
		]
	}
}


var storey_level: int = Global.storey_level
var room_index: int = Global.room_index

var scene
var max_room_number = 5
var room_number
var room
var room_class
var room_size = 16 * 32
var room_door_direction: Array
var old_room_door_direction: Array
var room_direction
var room_position
var player_spawn_position

@onready var player: Player = $"../Player"


func _ready() -> void:
	spawn_room_group()


func spawn_room_group():
	print("[rooms_generator]")
	var not_empty_room: Array = []
	room_number = 0
	room_direction = Vector2()
	room_position = Vector2()
	var old_room_position = Vector2()
	room = null
	player_spawn_position = null
	
	while room_number < max_room_number:
		if room_number == 0:
			room_position = Vector2(0, 0)
		else:
			room_direction = old_room_door_direction.back()
			room_position += room_direction
		
		if room_position in not_empty_room:
			print("[room_direction] ", room_direction)
			print("[room_position] ", room_position)
			print("######### repeat-break #########")
			print()
		else:
			old_room_position
			not_empty_room.push_back(room_position)
			room_door_direction = []
			
			if room_number > 0:
				var v
				match room_direction:
					Vector2(1, 0):
						v = Vector2(-1, 0)
					Vector2(-1, 0):
						v = Vector2(1, 0)
					Vector2(0, 1):
						v = Vector2(0, -1)
					Vector2(0, -1):
						v = Vector2(0, 1)
				room_door_direction.push_back(v)
			
			while room_door_direction.size() < 2:
				while "":
					var rp = room_position
					var orp = old_room_position
					var a = [Vector2(1,0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
					var b = a[randi() % a.size()]
					var x = rp.x - b.x == orp.x + 1 || rp.y - b.x == orp.x + 1
					if x:
						room_door_direction.push_back(b)
						break
				
				var v
				match randi_range(0, 3):
					0:
						v = Vector2(1, 0)
					1:
						v = Vector2(-1, 0)
					2:
						v = Vector2(0, 1)
					3:
						v = Vector2(0, -1)
				
				if room_door_direction.has(v):
					print("[room_door_direction] ", room_door_direction)
					print("######### repeat-break #########")
					print()
				else:
					room_door_direction.push_back(v)
			
			match room_number:
				0:
					room_class = "from"
				1:
					room_class = "fight"
				4:
					room_class = "fight"
			
			var key = str(room_door_direction)
			var data = room_data.get(room_class).get(key)
			room = load(data[randi() % data.size()]).instantiate()
			room.position.x = room_position.x * room_size
			room.position.y = room_position.y * room_size
			add_child(room)
			
			room_number += 1
			old_room_position = room_position
			old_room_door_direction = room_door_direction
			print("room_direction:  ", room_direction)
			print("room_door_direction:  ", room_door_direction)
			print("room_position:  ", room_position)
			print("not_emoty_room: ", not_empty_room)
			print("room_number: ", room_number)
			print("room_class: ", room_class)
			print()
	print("/[rooms_generator]")
