extends Node2D


var enemy_exited: bool = false
var direction: Vector2 = Vector2.ZERO
var knife_speed: int


func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta


func launch(initial_position: Vector2, dir: Vector2, speed: int):
	position = initial_position
	direction = dir
	#knokback_direction = dir
	knife_speed = speed
	
	rotation += dir.angle() + PI/4

func _on_body_exited(body: CharacterBody2D) -> void:
	if !enemy_exited:
		enemy_exited = true

func collide(body: CharacterBody2D):
	if enemy_exited:
		if body != null:
			#body.take_damage(damage, knockback_direction, konckback_force)
			pass
		queue_free()
