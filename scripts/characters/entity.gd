extends CharacterBody2D
class_name Entity

signal dead
signal hurt


@export var knockback_power: int = 300
@export var max_health: int = 20
@export var current_health: int = 20


func _ready() -> void:
	dead.connect(dead_handle)
	hurt.connect(hurt_handle)


func dead_handle():
	pass

func hurt_handle():
	pass
