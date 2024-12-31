extends Node
var a = FileFunction.get_file_list("res://rooms/room_group_rooms/fight_rooms/")

func _ready() -> void:
	print(FileFunction.get_file_list("res://rooms/room_group_rooms/end_rooms/"))
	print(FileFunction.get_file_list("res://rooms/room_group_rooms/fight_rooms/"))
	print(FileFunction.get_file_list("res://rooms/room_group_rooms/from_rooms/"))
