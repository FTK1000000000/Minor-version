extends Node2D


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
var room_amount: int
var room_number: int
var sum_of_enemy_price: int
var rng: RandomNumberGenerator = Global.rng

@onready var player: Player = $"../Player"


func run():
	compute_sum_of_enemy_price()
	rooms_generator()


func compute_sum_of_enemy_price():
	GlobalPlayerState.compute_player_wealth()
	
	var cp = Global.classes_data.property.get(GlobalPlayerState.classes).price
	var pw = GlobalPlayerState.wealth
	var deviation = cp / pw
	sum_of_enemy_price = \
	#rng.randi_range(
		#pw + pw * deviation,
		#pw - pw * deviation
	#)
	pw
	
	print("/[compute_sum_of_enemy_price] => ", sum_of_enemy_price, ", deviation: ", deviation)

func rand_direction() -> Vector2:
	var a = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
	var x = a[rng.randi() % a.size()]
	return x

func rooms_generator():
	print("[rooms_generator]")
	
	var storey_scene: String = storey_data.get(str(storey_level)).scene
	var room: Node = null
	var room_class: String = ""
	var player_spawn_position: Vector2 = Vector2()
	
	#room_group
	if !storey_data.get(str(storey_level)).storey_class == "boss_room":
		room_group_data = []
		branch_way_group_data = []
		room_amount = 0
		room_number = 0
		
		var branch_room_amount_group: Array
		var not_empty_room: Array
		var room_door_direction: Array
		var room_position: Vector2
		var room_direction: Vector2
		var branch_direction: Vector2
		var old_room_door_direction: Array
		var old_room_position: Vector2
		var old_room_data: Dictionary
		var repeat: bool = false
		var max_run_amount = 16
		var run_amount = 0
		
		#room generator
		max_room_amount = storey_data.get(str(storey_level)).room_amount
		if room_amount < max_room_amount:
			#main way
			print("[main_way]")
			main_way_room_amount = storey_data.get(str(storey_level)).main_way_room_amount
			max_run_amount = max_room_amount
			run_amount = 0
			while room_amount < main_way_room_amount:
				if run_amount >= max_room_amount:
					return recurrence()
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
						not_empty_room.pop_back()
						room_group_data.pop_back()
						old_room_data = room_group_data.back()
						old_room_door_direction = old_room_data.door_direction
						room_class = old_room_data.class
						room_position = old_room_data.position
						room_direction = old_room_data.direction
						room_door_direction = old_room_data.door_direction
						room_amount -= 1
						repeat = true
						
						print("break(repeat.pos) => index: " + str(room_group_data.size()) + ", old_room_data: ", old_room_data)
						print()
					else:
						repeat = false
						room_door_direction = []
						
						while room_door_direction.size() < 2:
							while room_door_direction.size() < 1:
								var v
								match old_room_door_direction.back():
									Vector2(1, 0): v = Vector2(-1, 0)
									Vector2(-1, 0): v = Vector2(1, 0)
									Vector2(0, 1): v = Vector2(0, -1)
									Vector2(0, -1): v = Vector2(0, 1)
								room_door_direction.push_back(v)
							
							if room_class == "end":
								break
							else:
								var direction = rand_direction()
								if direction in room_door_direction:
									print("break => repeat.dir")
									print()
									
									repeat = true
								else:
									repeat = false
									room_door_direction.push_back(direction)
				else:
					room_position = Vector2(0, 0)
					
					var a = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
					var v = a[rng.randi() % a.size()]
					room_door_direction.push_back(v)
				
				if !repeat:
					room_amount += 1
					old_room_position = room_position
					old_room_door_direction = room_door_direction
					not_empty_room.push_back(room_position)
					
					var data_group: Dictionary = {
						"class" = room_class,
						"index" = room_amount,
						"position" = room_position,
						"direction" = room_direction,
						"door_direction" = room_door_direction,
					}
					room_group_data.push_back(data_group)
					print("index: ", room_amount)
					print("room_class: ", room_class)
					print("room_position:  ", room_position)
					print("not_emoty_room: ", not_empty_room)
					print("room_direction:  ", room_direction)
					print("room_door_direction:  ", room_door_direction)
					#print("room_amount: ", room_amount)
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
				var remain_room_amount = max_room_amount - main_way_room_amount
				while branch_room_amount_group.size() < branch_way_amount:
					var v = (branch_way_room_amount if remain_room_amount >= branch_way_room_amount else remain_room_amount)
					remain_room_amount -= v
					branch_room_amount_group.push_back(v)
				
				#way
				var branch_data: Array
				var current_room_amount: int = 0
				var midway_room_index: Array
				while branch_way_group_data.size() < branch_way_amount:
					if run_amount >= max_room_amount:
							return recurrence()
					print("[way_generator]")
					
					var need_room_amount = branch_room_amount_group[branch_way_group_data.size()]
					midway_room_index = []
					for i in room_group_data:
						if i.class == "fight":
							midway_room_index.push_back(i.index)
					
					#var root_room_index = (rng.randi() % (room_group_data.size() - 2)) + 1
					var root_room_index = midway_room_index[rng.randi() % midway_room_index.size()]
					var root_room_data: Dictionary = room_group_data[root_room_index - 1]
					if root_room_data.door_direction.size() >= 4:
						return recurrence()
					
					var empty_direction: Array = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)]
					var not_empty_direction: Array = root_room_data.door_direction
					for pos in not_empty_room:
						#print("pos: ", pos)
						for dir in empty_direction:
							#print(true if not_empty_room[root_room_index] + dir == pos else false)
							if not_empty_room[root_room_index] + dir == pos:
								empty_direction.erase(dir)
								#print("empty_direction - ", dir)
								break
					#print("empty_direction => ", empty_direction)
					if empty_direction.is_empty():
						return recurrence()
					
					room_position = root_room_data.position
					old_room_position = root_room_data.position
					old_room_door_direction = root_room_data.door_direction
					branch_direction = empty_direction[rng.randi() % empty_direction.size()]
					room_direction = branch_direction
					root_room_data.door_direction.insert(root_room_data.door_direction.size() - 1, branch_direction)
					
					print("/[change_room_group_data](index: " + str(root_room_data.index) + ") => position: " + str(root_room_data.position) + ", door_direction: " + str(root_room_data.door_direction))
					#room
					max_run_amount = max_room_amount
					run_amount = 0
					branch_data = []
					while current_room_amount < need_room_amount:
						if run_amount >= max_room_amount:
							return recurrence()
						print("[room_generator]")
						
						room_class = ("fight" if current_room_amount < need_room_amount - 1 else "end")
						room_direction = (branch_direction if current_room_amount == 0 else old_room_door_direction.back())
						room_position += room_direction
						
						if room_position in not_empty_room:
							current_room_amount = (current_room_amount - 1 if current_room_amount != 0 else 0)
							room_amount = (room_amount - 1 if current_room_amount != 0 else 0)
							if !branch_data.is_empty(): not_empty_room.pop_back()
							branch_data.pop_back()
							old_room_data = (branch_data.back() if current_room_amount != 0 else root_room_data)
							old_room_door_direction = old_room_data.door_direction
							room_class = old_room_data.class
							room_position = old_room_data.position
							room_direction = old_room_data.direction
							room_door_direction = old_room_data.door_direction
							repeat = true
							
							print("break(repeat.pos) => index: " + str(old_room_data.index) + ", old_room_data: ", old_room_data)
							print()
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
									var direction = rand_direction()
									if direction in room_door_direction:
										#print("[room_door_direction] ", room_door_direction)
										print("break => repeat.dir")
										print()
										
										repeat = true
									else:
										repeat = false
										room_door_direction.push_back(direction)
						
						if !repeat:
							room_amount += 1
							current_room_amount += 1
							old_room_position = room_position
							old_room_door_direction = room_door_direction
							not_empty_room.push_back(room_position)
							
							var data_group: Dictionary = {
								"class" = room_class,
								"index" = room_amount,
								"position" = room_position,
								"direction" = room_direction,
								"door_direction" = room_door_direction,
								"branch_root_index" = root_room_index
							}
							branch_data.push_back(data_group)
							print("index: ", room_group_data.size() + branch_data.size())
							print("index: ", room_amount)
							print("room_class: ", room_class)
							print("room_position:  ", room_position)
							print("not_emoty_room: ", not_empty_room)
							print("room_direction:  ", room_direction)
							print("room_door_direction:  ", room_door_direction)
							#print("room_amount: ", room_amount)
							print("/[room_generator]")
							print()
						run_amount += 1
					branch_way_group_data.push_back(branch_data)
					current_room_amount = 0
					print("/[way_generator]")
				for way in branch_way_group_data:
					for i in way:
						room_group_data.push_back(i)
				print("/[branch_way]")
				print()
		
		#room spawn
		if room_group_data.size() == max_room_amount:
			var save_room_data = room_group_data.duplicate()
			while room_amount > 1 && room_number != max_room_amount:
				if save_room_data.is_empty():
					return recurrence()
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
					room = load(path.get(path.keys()[rng.randi() % path.size()])).instantiate()
					room.position.x = room_position.x * ROOM_SIZE
					room.position.y = room_position.y * ROOM_SIZE
					room_number += 1
					add_child(room)
					
					print("room_number: ", room_number)
					print("room_class: ", room_class)
					print("room_position: ", room_position)
					print("dir_door: ", key)
					print("/[room_spawn]")
					print()
		room_enemy_group_data_generator()
	
	#boss
	else:
		print("[room_spawn]")
		var path = FileFunction.get_file_list(room_data.scene.get(storey_scene).boss)
		if storey_data.get(str(storey_level)).has("boss"):
			var boss = storey_data.get(str(storey_level)).boss
			room = load(path.get(boss)).instantiate()
		else:
			room = load(path.get(path.keys()[rng.randi() % path.size()])).instantiate()
		add_child(room)
		
		player_spawn_position = room.player_spawn_position
		GlobalPlayerState.player.position = player_spawn_position
		
		print("/[room_spawn]")
		print()
	print("/[room_group_generator]")

func recurrence():
	print("Some years ago, I engaged passage from Charleston, S. C, to the city of New York, in the fine packet-ship 'Independence,' Captain Hardy.")
	for child in get_children():
		remove_child(child)
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
		var key: String = enemy_data_list[rng.randi() % enemy_data_list.size()]
		enemy = enemy_file_list.get(key)
		enemy_group_data.push_back(enemy)
		current_enemys_price -= Global.enemy_data.get(key).price
	
	if current_enemys_price < 0:
		enemy_group_generator()
	else:
		print("/[enemy_group_data_generator] => enemy_group_data: ", enemy_group_data)
		print()
		return enemy_group_data
