extends Node2D


@export var bgm: AudioStream

@onready var player = get_node("Player")


func _ready() -> void:
	if bgm:
		SoundManager.play_bgm(bgm)


#func to_dict():
	#pass
#
#func from_dict(dict: Dictionary):
	#pass
