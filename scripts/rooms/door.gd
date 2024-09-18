extends StaticBody2D


@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func open():
	visible = false
	collision_shape_2d.set_disabled(true)

func close():
	visible = true
	collision_shape_2d.set_deferred("disabled", false)
