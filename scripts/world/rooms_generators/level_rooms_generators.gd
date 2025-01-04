extends Node2D


const aroom_data = {
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


const ROOM_DATA_PATH = "res://data/room_data.json"

const ROOM_SIZE: int = 27 * 32

enum LEVEL_SCENE {
	goblin,
	ogre,
	vampire
}

var scene: LEVEL_SCENE
var storey_data: Dictionary = Global.storey_data
var storey_level: int = Global.storey_level
var room_data: Dictionary = FileFunction.json_as_dictionary(ROOM_DATA_PATH)
var room_group_data: Array = []
var branch_way_group_data: Array = []
var room_enemy_group_data: Array = []
var max_room_amount: int
var main_way_room_amount: int
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
	
	var storey_scene: String = storey_data.get(str(storey_level)).scene
	var room: Node = null
	var room_class: String = ""
	var player_spawn_position: Vector2 = Vector2()
	
	if !storey_data.get(str(storey_level)).storey_class == "boss_room":
		room_group_data = []
		room_amount = 0
		room_number = 0
		
		var branch_room_amount_group: Array
		var branch_way_amount: int
		var not_empty_room: Array
		var room_door_direction: Array
		var room_position: Vector2
		var room_direction: Vector2
		var branch_direction: Vector2
		var old_room_door_direction: Array
		var old_room_position: Vector2
		var old_room_data: Dictionary
		var repeat: bool = false
		
		#room generator
		max_room_amount = storey_data.get(str(storey_level)).room_amount
		if room_amount < max_room_amount:
			#main way
			print("[main_way]")
			main_way_room_amount = storey_data.get(str(storey_level)).main_way_room_amount
			while room_amount < main_way_room_amount:
				print("[room_generator]")
				
				if room_amount == 0:
					room_class = "from"
				elif room_amount < main_way_room_amount - 1:
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
						
						old_room_data = room_group_data.pop_back()
						room_class = old_room_data.class
						room_position = old_room_data.position
						room_direction = old_room_data.direction
						room_door_direction = old_room_data.door_direction
						room_amount -= 1
						print("room_amount: ", room_amount)
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
			if room_amount < max_room_amount:
				print("[branch_way]")
				branch_way_room_amount = storey_data.get(str(storey_level)).branch_way_room_amount
				branch_way_amount = (
					(max_room_amount - main_way_room_amount) / branch_way_room_amount + 1
					if (max_room_amount - main_way_room_amount) % branch_way_room_amount != 0 else
					(max_room_amount - main_way_room_amount) / branch_way_room_amount
				)
				while branch_room_amount_group.size() < branch_way_amount:
					var a = branch_way_room_amount
					var x = max_room_amount - main_way_room_amount
					var v = (a if x % a == 0 else x % a)
					x - v
					branch_room_amount_group.push_back(v)
				
				#way
				var branch_data: Array
				var current_room_amount: int = 0
				while branch_way_group_data.size() < branch_way_amount:
					var need_room_amount = branch_room_amount_group[branch_way_group_data.size()]
					var root_room_index = (randi() % (room_group_data.size() - 2)) + 1
					var root_room_data: Dictionary = room_group_data[root_room_index]
					if root_room_data.door_direction.size() >= 4:
						continue
					
					var empty_direction: Array = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
					var not_empty_direction: Array = root_room_data.door_direction
					for i in not_empty_direction:
						empty_direction.erase(i)
					
					room_position = root_room_data.position
					old_room_position = root_room_data.position
					old_room_door_direction = root_room_data.door_direction
					branch_direction = empty_direction[randi() % empty_direction.size()]
					match branch_direction:
						Vector2(1, 0): branch_direction = Vector2(-1, 0)
						Vector2(-1, 0): branch_direction = Vector2(1, 0)
						Vector2(0, 1): branch_direction = Vector2(0, -1)
						Vector2(0, -1): branch_direction = Vector2(0, 1)
					room_direction = branch_direction
					root_room_data.door_direction.insert(root_room_data.door_direction.size() - 1, branch_direction)
					
					print("/[change_room_group_data](index: " + str(root_room_index + 1) + ") => position: " + str(root_room_data.position) + ", door_direction: " + str(root_room_data.door_direction))
					#room
					while current_room_amount < need_room_amount:
						print("[room_generator]")
						
						room_class = ("fight" if current_room_amount < need_room_amount - 1 else "end")
						room_direction = (branch_direction if current_room_amount == 0 else old_room_door_direction.back())
						room_position += room_direction
						
						if room_position in not_empty_room:
							print("[room_direction] ", room_direction)
							print("[room_position] ", room_position)
							print(root_room_data)
							print(root_room_index)
							print(not_empty_room)
							print("######### repeat-break #########.pos")
							print()
							
							#old_room_data = room_group_data.pop_back()
							old_room_data = branch_data.pop_front()
							room_class = old_room_data.class
							room_position = old_room_data.position
							room_direction = old_room_data.direction
							room_door_direction = old_room_data.door_direction
							room_amount -= 1
							current_room_amount -= 1
							print(current_room_amount)
							repeat = true
						else:
							repeat = false
							room_door_direction = []
							
							while room_door_direction.size() < 2:
								if room_door_direction.size() < 1:
									var v
									var x = (
										branch_direction
										if current_room_amount == 0 else
										old_room_door_direction.back())
									match x:
										Vector2(1, 0): v = Vector2(-1, 0)
										Vector2(-1, 0): v = Vector2(1, 0)
										Vector2(0, 1): v = Vector2(0, -1)
										Vector2(0, -1): v = Vector2(0, 1)
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
							print(room_door_direction)
							
							var data_group: Dictionary = {
								"class" = room_class,
								"position" = room_position,
								"direction" = room_direction,
								"door_direction" = room_door_direction,
								"branch_root_index" = root_room_index
							}
							branch_data.push_back(data_group)
							print("index: ", room_group_data.size() + branch_data.size())
							print("room_class: ", room_class)
							print("room_position:  ", room_position)
							print("not_emoty_room: ", not_empty_room)
							print("room_direction:  ", room_direction)
							print("room_door_direction:  ", room_door_direction)
							print("room_amount: ", room_amount)
							print("/[room_generator]")
							print()
					print("current_room_amount", current_room_amount)
					print("current_branch_way", branch_way_group_data.size())
					print(branch_data)
					
					if branch_data.is_empty():
						break
					else:
						branch_way_group_data.push_back(branch_data)
				for way in branch_way_group_data:
					for i in way:
						room_group_data.push_back(i)
				print("/[branch_way]")
				print()
		
		#if room_group_data[0].class != "from":
			#return recurrence()
		#else:
			#print(room_group_data[0].class)
		
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
							
							var compute_key = func(key: Array) -> String:
								var v: String
								var a = key.duplicate()
								if a.has(Vector2(-1, 0)):
									v += "left"
									a.erase(Vector2(-1, 0))
								if a.has(Vector2(1, 0)):
									v += ("right" if a.size() >= key.size() else ", right")
									a.erase(Vector2(1, 0))
								if a.has(Vector2(0, -1)):
									v += ("up" if a.size() >= key.size() else ", up")
									a.erase(Vector2(0, -1))
								if a.has(Vector2(0, 1)):
									v += ("down" if a.size() >= key.size() else ", down")
									a.erase(Vector2(0, 1))
								v = v.insert(0, "[")
								v = v.insert(v.length(), "]")
								return v
							var key = compute_key.call(room_door_direction)
							var path = FileFunction.get_file_list(room_data.scene.get(storey_scene).get(room_class).get(key))
							room = load(path.get(path.keys()[randi() % path.size()])).instantiate()
							room.position.x = room_position.x * ROOM_SIZE
							room.position.y = room_position.y * ROOM_SIZE
							room_number += 1
							add_child(room)
							
							print("room_number: ", room_number)
							print("room_class: ", room_class)
							print("room_position: ", room_position)
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
		
		var range = room_data.scene.get(storey_scene).boss.values()
		room = load(range[randi() % range.size()]).instantiate()
		add_child(room)
		
		player_spawn_position = room.player_spawn_position
		GlobalPlayerState.player.position = player_spawn_position
		
		print("/[room_spawn]")
		print()
	print("/[room_group_generator]")

func recurrence():
	for child in get_children():
		remove_child(child)
		print("(recurrence)")
	print("(/recurrence)")
	rooms_generator()
#摆了，重跑吧

func room_enemy_group_data_generator():
	print("[room_enemy_group_generator]")
	
	var group_fight_room_amount: int = max_room_amount - 2
	while room_enemy_group_data.size() < group_fight_room_amount:
		room_enemy_group_data.push_back(enemy_group_generator())
	
	print("/[room_enemy_group_generator] => room_enemy_group_data: ", room_enemy_group_data)
	print()

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
