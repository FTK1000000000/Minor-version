extends StaticBody2D
class_name DESTRUCTBLE_COVER


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_chart: StateChart = $StateChart
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var current_health: int


func _ready() -> void:
	state_chart.send_event("idle")
	current_health = 20


func _on_idle_state_entered() -> void:
	print_debug("idle")


func _on_hurt_state_entered() -> void:
	if current_health < 0:
		sprite_2d.frame = 2
		collision_shape_2d.disabled = true
	elif current_health < 10:
		sprite_2d.frame = 1
	state_chart.send_event("idle")
	print_debug("hurt")
