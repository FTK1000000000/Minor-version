extends Area2D
class_name Hurtbox

@onready var parent = get_node("..")


func take_damage(dam: int, dir: Vector2, force: int):
	parent.current_health -= dam
	if !parent is StaticBody2D: parent.velocity += dir * force
	parent.state_chart.send_event("hurt")
