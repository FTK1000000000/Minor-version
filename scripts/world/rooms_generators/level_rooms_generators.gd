extends Node2D


const room_data = {
	"scene": {
		"goblin": {
			"from": {
				"[(1, 0)]": [
					"res://rooms/from_rooms/right/0.tscn",
				],
				"[(-1, 0)]": [
					"res://rooms/from_rooms/left/0.tscn",
				],
				"[(0, 1)]": [
					"res://rooms/from_rooms/down/0.tscn",
				],
				"[(0, -1)]": [
					"res://rooms/from_rooms/up/0.tscn",
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
				],
				
				#"[(1, 0), (-1, 0)]": [
					#"res://rooms/fight_rooms/left,right/0.tscn",
					#"res://rooms/fight_rooms/left,right/1.tscn"
				#],
				#"[(-1, 0), (1, 0)]": [
					#"res://rooms/fight_rooms/left,right/0.tscn",
					#"res://rooms/fight_rooms/left,right/1.tscn"
				#],
				#"[(0, 1), (0, -1)]": [
					#"res://rooms/fight_rooms/up,down/0.tscn",
					#"res://rooms/fight_rooms/up,down/1.tscn"
				#],
				#"[(0, -1), (0, 1)]": [
					#"res://rooms/fight_rooms/up,down/0.tscn",
					#"res://rooms/fight_rooms/up,down/1.tscn"
				#],
				#"[(1, 0), (0, 1)]": [
					#"res://rooms/fight_rooms/right,down/0.tscn",
				#],
				#"[(0, 1), (1, 0)]": [
					#"res://rooms/fight_rooms/right,down/0.tscn",
				#],
				#"[(1, 0), (0, -1)]": [
					#"res://rooms/fight_rooms/right,up/0.tscn",
				#],
				#"[(0, -1), (1, 0)]": [
					#"res://rooms/fight_rooms/right,up/0.tscn",
				#],
				#"[(-1, 0), (0, 1)]": [
					#"res://rooms/fight_rooms/left,down/0.tscn"
				#],
				#"[(0, 1), (-1, 0)]": [
					#"res://rooms/fight_rooms/left,down/0.tscn",
				#],
				#"[(-1, 0), (0, -1)]": [
					#"res://rooms/fight_rooms/left,up/0.tscn",
				#],
				#"[(0, -1), (-1, 0)]": [
					#"res://rooms/fight_rooms/left,up/0.tscn",
				#],
			},
			"end": {
				"[(1, 0)]": [
					"res://rooms/end_rooms/right/0.tscn",
				],
				"[(-1, 0)]": [
					"res://rooms/end_rooms/left/0.tscn",
				],
				"[(0, 1)]": [
					"res://rooms/end_rooms/down/0.tscn",
				],
				"[(0, -1)]": [
					"res://rooms/end_rooms/up/0.tscn",
				],
			},
			"boss": {
				"slime": "res://rooms/boss_rooms/slime.tscn",
			}
		}
	}
}

const ROOM_SIZE: int = 27 * 32

enum LEVEL_SCENE {
	goblin,
	ogre,
	vampire
}


var storey_data: Dictionary = Global.storey_data
var storey_level: int = Global.storey_level
var scene: LEVEL_SCENE
var room_group_data: Array = []
var room_enemy_group_data: Array = []
var max_room_amount: int = 5
var main_way_room_amount: int = 5
var branch_way_room_amount: int
var branch_way_amount: int
var room_amount: int = 0
var room_number: int = 0
var sum_of_enemy_price: int = 0

@onready var player: Player = $"../Player"


func _ready() -> void:
	compute_sum_of_enemy_price()
	rooms_generator()
	enemy_group_generator()


func compute_sum_of_enemy_price():
	GlobalPlayerState.compute_player_wealth()
	
	var cp = Global.classes_data.property.get(GlobalPlayerState.player_classes).price
	var pw = GlobalPlayerState.player_wealth
	var deviation = cp / pw
	sum_of_enemy_price = \
	#randi_range(
		#pw + pw * deviation,
		#pw - pw * deviation
	#)
	pw
	
	print("[compute_sum_of_enemy_price] => ", sum_of_enemy_price, ", deviation: ", deviation)

func rooms_generator():
	print("[rooms_generator]")
	
	var current_storey_scene: String = storey_data.get(storey_level).scene
	var room: Node = null
	var room_class: String = ""
	var player_spawn_position: Vector2 = Vector2()
	
	if !storey_data.get(storey_level).storey_class == "boss_room":
		room_group_data = []
		room_amount = 0
		room_number = 0
		
		var branch_group: Array = []
		var not_empty_room: Array = []
		var room_door_direction: Array = []
		var old_room_door_direction: Array = []
		var room_position: Vector2 = Vector2()
		var old_room_position: Vector2 = Vector2()
		var room_direction: Vector2 = Vector2()
		var branch_direction: Vector2 = Vector2()
		var repeat: bool = false
		
		#room generator
		max_room_amount = storey_data.get(storey_level).room_amount
		if room_amount < max_room_amount:
			#main way
			print("[main_way]")
			while room_amount < main_way_room_amount:
				print("[room_generator]")
				
				if room_amount == 0:
					room_class = "from"
				elif room_amount < max_room_amount - 1:
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
						room_amount - 1
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
								var a = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
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
					
					var a = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
					var v = a[randi() % a.size()]
					room_door_direction.push_back(v)
				
				if !repeat:
					room_amount += 1
					old_room_position = room_position
					old_room_door_direction = room_door_direction
					not_empty_room.push_back(room_position)
					
					var data_group: Dictionary = {
						"class" = room_class,
						"position" = room_position,
						"direction" = room_direction,
						"door_direction" = room_door_direction,
					}
					room_group_data.push_back(data_group)
					print("index: ", room_group_data.size())
					print("room_class: ", room_class)
					print("room_position:  ", room_position)
					print("not_emoty_room: ", not_empty_room)
					print("room_direction:  ", room_direction)
					print("room_door_direction:  ", room_door_direction)
					print("room_amount: ", room_amount)
					print("/[room_generator]")
					print()
			print("/[main_way]")
			print()
			
			#branch way
			print("[branch_way]")
			branch_way_room_amount = storey_data.get(storey_level).branch_way_room_amount
			branch_way_amount = (
				(max_room_amount - main_way_room_amount) / branch_way_room_amount + 1
				if (max_room_amount - main_way_room_amount) % branch_way_room_amount == 0 else
				(max_room_amount - main_way_room_amount) / branch_way_room_amount
			)
			while branch_group.size() < branch_way_amount:
				var a = branch_way_room_amount
				var x = max_room_amount - main_way_room_amount
				var v = (a if x % a == 0 else x % a)
				if x % a == 0: v = a
				else: v = x % a
				x - v
				branch_group.push_back(v)
			
			while room_amount < max_room_amount:
				var need_room_amount = branch_group.pop_front()
				var current_room_amount: int = 0
				var root_room_index = (randi() % (room_group_data.size() - 2)) + 1
				var root_room_data = room_group_data[root_room_index]
				var empty_direction: Array = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
				var not_empty_direction: Array = [
					room_group_data[root_room_index + 1].direction,
					room_group_data[root_room_index - 1].direction
				]
				for i in not_empty_direction:
					empty_direction.erase(i)
				
				old_room_door_direction = root_room_data.door_direction
				branch_direction = empty_direction[randi() % empty_direction.size()]
				var change_data_group: Dictionary = {
					"class" = root_room_data.class,
					"position" = root_room_data.position,
					"direction" = root_room_data.direction,
					"door_direction" = root_room_data.door_direction.insert(root_room_data.door_direction.size() - 1 - 1, branch_direction),
				}
				room_group_data.push_back(change_data_group)
				room_group_data.remove_at(root_room_index)
				print("/[change_room_group_data](index: " + root_room_index + ") => door_direction: " + change_data_group.door_direction)
				
				while current_room_amount < need_room_amount:
					print("[room_generator]")
					
					room_class = ("fight" if current_room_amount < need_room_amount - 1 else "end")
					room_direction = old_room_door_direction[old_room_door_direction.size() - 1 - 1]
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
						room_amount -= 1
						current_room_amount -= 1
						repeat = true
					else:
						repeat = false
						room_door_direction = []
						
						while room_door_direction.size() < 2:
							if room_door_direction.size() < 1:
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
								var a = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
								var x = a[randi() % a.size()]
								
								if room_door_direction.has(x):
									print("[room_door_direction] ", room_door_direction)
									print("######### repeat-break #########")
									print()
									
									repeat = true
								else:
									repeat = false
									room_door_direction.push_back(x)
					
					if !repeat:
						room_amount += 1
						current_room_amount += 1
						old_room_position = room_position
						old_room_door_direction = room_door_direction
						not_empty_room.push_back(room_position)
						
						var data_group: Dictionary = {
							"class" = room_class,
							"position" = room_position,
							"direction" = room_direction,
							"door_direction" = room_door_direction,
						}
						room_group_data.push_back(data_group)
						print("room_group_data: ", room_group_data.size())
						print("room_class: ", room_class)
						print("room_position:  ", room_position)
						print("not_emoty_room: ", not_empty_room)
						print("room_direction:  ", room_direction)
						print("room_door_direction:  ", room_door_direction)
						print("room_amount: ", room_amount)
						print("/[room_generator]")
						print()
				print("/[branch_way]")
				print()
		
		#room spawn
		if !(room_amount < max_room_amount):
			var save_room_data = room_group_data.duplicate()
			if save_room_data.size() == max_room_amount:
				while room_amount > 1:
					if room_number == max_room_amount:
						break
					else:
						if save_room_data.size() == 0:
							for child in get_children():
								remove_child(child)
								print("(recurrence)")
							rooms_generator()
							print("(/recurrence)")
						else:
							print("[room_spawn]")
							
							if room_number == 1:
								player_spawn_position = room.player_spawn_position
								GlobalPlayerState.player.position = player_spawn_position
							
							var data = save_room_data.pop_front()
							room_class = data.class
							room_position = data.position
							room_direction = data.direction
							room_door_direction = data.door_direction
							
							var key = str(room_door_direction)
							var path = room_data.scene.get(current_storey_scene).get(room_class).get(key)
							room = load(path[randi() % path.size()]).instantiate()
							room.position.x = room_position.x * ROOM_SIZE
							room.position.y = room_position.y * ROOM_SIZE
							room_number += 1
							add_child(room)
							
							print("room_number: ", room_number)
							print("room_class: ", room_class)
							print("key: ", key)
							print("/[room_spawn]")
							print()
			else:
				for child in get_children():
					remove_child(child)
					print("(recurrence)")
				rooms_generator()
				print("(/recurrence)")
		room_enemy_group_data_generator()
	else:
		print("[room_spawn]")
		
		var range = room_data.scene.get(current_storey_scene).boss.values()
		room = load(range[randi() % range.size()]).instantiate()
		add_child(room)
		
		player_spawn_position = room.player_spawn_position
		GlobalPlayerState.player.position = player_spawn_position
		
		print("/[room_spawn]")
		print()
	
	print("/[room_group_generator]")

func room_enemy_group_data_generator():
	print("[room_enemy_group_generator]")
	
	var group_fight_room_amount: int = max_room_amount - 2
	while room_enemy_group_data.size() < group_fight_room_amount:
		room_enemy_group_data.push_back(enemy_group_generator())
	
	print("/[room_enemy_group_generator] => room_enemy_group_data: ", room_enemy_group_data)

func enemy_group_generator():
	var enemy_group_data: Array
	var group_fight_room_amount: int = max_room_amount - 2
	var enemy_group_price = sum_of_enemy_price / group_fight_room_amount as int
	var current_enemys_price = enemy_group_price
	
	while current_enemys_price > 0:
		var enemy: String
		var enemy_scene_file: PackedScene
		var enemy_file_list: Dictionary = FileFunction.get_file_list(Global.ENEMY_DIRECTORY)
		var enemy_data_list: Array = Global.enemy_data.keys()
		var key: String = enemy_data_list[randi() % enemy_data_list.size()]
		enemy = enemy_file_list.get(key)
		enemy_group_data.push_back(enemy)
		current_enemys_price -= Global.enemy_data.get(key).price
	
	if current_enemys_price < 0:
		enemy_group_generator()
	else:
		print("/[enemy_group_data_generator] => enemy_group_data: ", enemy_group_data)
		print()
		return enemy_group_data
