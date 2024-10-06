extends Ammo


func _ready() -> void:
	damage = 5
	
	dead()

func _on_area_entered(area: Area2D) -> void:
	area.take_damage(damage, knockback_direction, knockback_force)
	
	knife_speed = 0
	area.add_child(self)
	collision_shape_2d.queue_free()

func _on_body_entered(body: TileMapLayer) -> void:
	knife_speed = 0
	queue_free()
