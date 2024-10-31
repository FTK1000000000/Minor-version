extends Node2D


@onready var root: World = $"../.."
@onready var end_room_container: Node2D = $Rooms/EndRoom
@onready var from_room_container: Node2D = $Rooms/FromRoom

var from_room: Node2D

@export var index: int


func _ready() -> void:
	for room in from_room_container.get_children():
		from_room = room
		print(from_room.name)
