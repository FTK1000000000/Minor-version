extends Node
class_name Room


@onready var tags: Node2D = $Tags

var up_door: Vector2
var down_door: Vector2
var left_door: Vector2
var right_door: Vector2


func _ready() -> void:
	if tags.get_node("Up"): left_door = tags.get_node("Up").global_position
	if tags.get_node("Down"): left_door = tags.get_node("Down").global_position
	if tags.get_node("Left"): left_door = tags.get_node("Left").global_position
	if tags.get_node("Right"): left_door = tags.get_node("Right").global_position
