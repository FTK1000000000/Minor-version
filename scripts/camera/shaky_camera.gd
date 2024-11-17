extends Camera2D


@export var recovery_speed: float = 16
var strength: float = 0


func _process(delta: float) -> void:
	offset = Vector2(
		randf_range(-strength, +strength),
		randf_range(-strength, +strength)
	)
	strength = move_toward(strength, 0, recovery_speed * delta)


func camera_should_shake(amount: float):
	strength += amount
