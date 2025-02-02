extends CharacterBody2D
class_name Entity

signal deading
signal hurting
signal attacking


@export var max_health: int = 20
@export var current_health: int = 20
@export var hurt_ready_time: float = Common.HURT_READY_TIME


func _ready() -> void:
	deading.connect(dead_handle)
	hurting.connect(hurt_handle)


func dead_handle():
	pass

func hurt_handle():
	pass
