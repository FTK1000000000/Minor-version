extends Node2D
class_name WORLD


@onready var player = get_node("Player")

@export var bgm: AudioStream

var room_group_index: int


func _ready() -> void:
	room_group_index = Global.room_group_index
	
	if bgm:
		SoundManager.play_bgm(bgm)
