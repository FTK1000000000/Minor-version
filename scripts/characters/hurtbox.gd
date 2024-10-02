extends Area2D
class_name Hurtbox

@onready var parent: CharacterBody2D = get_node("..")


func take_damage(dam: int, dir: Vector2, force: int):
	parent.current_health -= dam
	parent.velocity += dir * force
	parent.state_chart.send_event("hurt")
