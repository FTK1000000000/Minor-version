extends Marker2D


const FLOATING_NUMBERS = preload("res://ui/floating_numbers.tscn")


func popup(damage: int, direction: Vector2):
	var damage_number = FLOATING_NUMBERS.instantiate()
	damage_number.position = global_position
	damage_number.get_node("Label").text = str(damage)
	
	var disturbance_range = Vector2(randf_range(1, -1), randf_range(1, -1)) * 8
	
	var tween = get_tree().create_tween()
	var v = global_position + direction * 10 + disturbance_range
	tween.tween_property(damage_number, "position", v, 0.8)
	
	get_tree().current_scene.add_child(damage_number)
