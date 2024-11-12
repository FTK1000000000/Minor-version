extends Area2D
class_name Hitbox


@export var collision_ready: bool = true
@export var target: Area2D = null

@export var damage: int = 10
@export var knockback_force: int = 300
@export var knockback_direction: Vector2 = Vector2.ZERO
@export var ready_time: int = 1


func _process(_delta: float) -> void:
	if collision_ready && target:
		hit(target)
		collision_ready = false
		await get_tree().create_timer(ready_time).timeout
		
		collision_ready = true


func hit(area: Area2D):
	knockback_direction = (area.global_position - global_position).normalized()
	area.take_damage(damage, knockback_direction, knockback_force)


func _on_area_entered(area: Area2D) -> void:
	target = area


func _on_area_exited(_area: Area2D) -> void:
	target = null
