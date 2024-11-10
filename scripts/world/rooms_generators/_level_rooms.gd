extends Node2D


const room_data = {
	"from": {
		"[(1, 0)]": [
			"res://rooms/from_rooms/right/0.tscn"
		],
		"[(-1, 0)]": [
			"res://rooms/from_rooms/left/0.tscn"
		],
		"[(0, 1)]": [
			"res://rooms/from_rooms/down/0.tscn"
		],
		"[(0, -1)]": [
			"res://rooms/from_rooms/up/0.tscn"
		],
	},
	"fight": {
		"[(1, 0), (-1, 0)]": [
			"res://rooms/fight_rooms/left,right/0.tscn",
			"res://rooms/fight_rooms/left,right/1.tscn"
		],
		"[(-1, 0), (1, 0)]": [
			"res://rooms/fight_rooms/left,right/0.tscn",
			"res://rooms/fight_rooms/left,right/1.tscn"
		],
		"[(0, 1), (0, -1)]": [
			"res://rooms/fight_rooms/up,down/0.tscn",
			"res://rooms/fight_rooms/up,down/1.tscn"
		],
		"[(0, -1), (0, 1)]": [
			"res://rooms/fight_rooms/up,down/0.tscn",
			"res://rooms/fight_rooms/up,down/1.tscn"
		],
		"[(1, 0), (0, 1)]": [
			"res://rooms/fight_rooms/right,down/0.tscn",
		],
		"[(0, 1), (1, 0)]": [
			"res://rooms/fight_rooms/right,down/0.tscn",
		],
		"[(1, 0), (0, -1)]": [
			"res://rooms/fight_rooms/right,up/0.tscn",
		],
		"[(0, -1), (1, 0)]": [
			"res://rooms/fight_rooms/right,up/0.tscn",
		],
		"[(-1, 0), (0, 1)]": [
			"res://rooms/fight_rooms/left,down/0.tscn"
		],
		"[(0, 1), (-1, 0)]": [
			"res://rooms/fight_rooms/left,down/0.tscn",
		],
		"[(-1, 0), (0, -1)]": [
			"res://rooms/fight_rooms/left,up/0.tscn",
		],
		"[(0, -1), (-1, 0)]": [
			"res://rooms/fight_rooms/left,up/0.tscn",
		]
	},
	"end": {
		"[(1, 0)]": [
			"res://rooms/from_rooms/right/0.tscn"
		],
		"[(-1, 0)]": [
			"res://rooms/from_rooms/left/0.tscn"
		],
		"[(0, 1)]": [
			"res://rooms/from_rooms/down/0.tscn"
		],
		"[(0, -1)]": [
			"res://rooms/from_rooms/up/0.tscn"
		],
	},
}

const ROOM_SIZE: int = 27 * 32

enum LEVEL_SCENE {
	a,
	aa
}


@export var storey_level: int = Global.storey_level
@export var room_index: int = Global.room_index

@export var scene: LEVEL_SCENE
@export var room_group_data: Array = []
@export var max_room_number: int = 5
@export var room_number: int = 0
@export var number: int = 0


@onready var player: Player = $"../Player"


func _ready() -> void:
	spawn_room_group()


func spawn_room_group():
	print("{rooms_generator}")
	
	room_group_data = []
	room_number = 0
	number = 0
	
	var room: Node = null
	var room_class: String = ""
	var not_empty_room: Array = []
	var room_door_direction: Array = []
	var old_room_door_direction: Array = []
	var room_position: Vector2 = Vector2()
	var old_room_position: Vector2 = Vector2()
	var room_direction: Vector2 = Vector2()
	var player_spawn_position: Vector2 = Vector2()
	var repeat: bool = false
	
	while room_number < max_room_number:
		print("[room_generator]")
		
		if room_number == 0:
			room_class = "from"
		elif room_number < max_room_number - 1:
			room_class = "fight"
		else:
			room_class = "end"
		
		if room_class != "from":
			room_direction = old_room_door_direction.back()
			room_position += room_direction
			
			if room_position in not_empty_room:
				print("[room_direction] ", room_direction)
				print("[room_position] ", room_position)
				print("######### repeat-break #########")
				print()
				
				var old_room_data = room_group_data.pop_front()
				room_class = old_room_data.class
				room_position = old_room_data.position
				room_direction = old_room_data.direction
				room_door_direction = old_room_data.door_direction
				room_number - 1
				repeat = true
			else:
				repeat = false
				room_door_direction = []
				
				while room_door_direction.size() < 2:
					while room_door_direction.size() < 1:
						var v
						match old_room_door_direction.back():
							Vector2(1, 0):
								v = Vector2(-1, 0)
							Vector2(-1, 0):
								v = Vector2(1, 0)
							Vector2(0, 1):
								v = Vector2(0, -1)
							Vector2(0, -1):
								v = Vector2(0, 1)
						room_door_direction.push_back(v)
					
					if room_class == "end":
						break
					else:
						var a = [Vector2(1,0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
						var x = a[randi() % a.size()]
						
						if room_door_direction.has(x):
							print("[room_door_direction] ", room_door_direction)
							print("######### repeat-break #########")
							print()
							
							repeat = true
						else:
							repeat = false
							room_door_direction.push_back(x)
		else:
			room_position = Vector2(0, 0)
			
			var a = [Vector2(1,0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
			var v = a[randi() % a.size()]
			room_door_direction.push_back(v)
		
		if !repeat:
			room_number += 1
			old_room_position = room_position
			old_room_door_direction = room_door_direction
			not_empty_room.push_back(room_position)
			
			var data_group: Dictionary = {}
			data_group = {
				"class" = room_class,
				"position" = room_position,
				"direction" = room_direction,
				"door_direction" = room_door_direction
			}
			room_group_data.push_back(data_group)
			print("room_group_data: ", room_group_data.size())
			print("room_class: ", room_class)
			print("room_position:  ", room_position)
			print("not_emoty_room: ", not_empty_room)
			print("room_direction:  ", room_direction)
			print("room_door_direction:  ", room_door_direction)
			print("room_number: ", room_number)
			print("/[room_generator]")
			print()
	
	if !(room_number < max_room_number):
		var save_room_data = room_group_data.duplicate()
		while room_number > 1:
			if number == max_room_number:
				break
			else:
				if save_room_data.size() == 0:
					for child in get_children():
						remove_child(child)
					spawn_room_group()
				else:
					print("[room_spawn]")
					
					var data = save_room_data.pop_front()
					room_class = data.class
					room_position = data.position
					room_direction = data.direction
					room_door_direction = data.door_direction
					
					var key = str(room_door_direction)
					var path = room_data.get(room_class).get(key)
					room = load(path[randi() % path.size()]).instantiate()
					room.position.x = room_position.x * ROOM_SIZE
					room.position.y = room_position.y * ROOM_SIZE
					number += 1
					add_child(room)
					
					print("number: ", number)
					print("room_class: ", room_class)
					print("key: ", key)
					print("/[room_spawn]")
					print()
	
	print("/{room_group_generator}")
