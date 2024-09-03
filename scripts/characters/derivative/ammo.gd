extends Hitbox


var collision_exited: bool = false

var direction: Vector2 = Vector2.ZERO
var knife_speed: int
var life_cycle: float = 5


func _ready() -> void:
	damage = 25
	
	dead()

func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta


func dead():
	await get_tree().create_timer(life_cycle).timeout
	queue_free()

func launch(initial_position: Vector2, dir: Vector2, speed: int):
	position = initial_position
	direction = dir
	knockback_direction = dir
	knife_speed = speed
	
	rotation += dir.angle() + PI/4


func _on_area_entered(area: Area2D) -> void:
	area.take_damage(damage, knockback_direction, knockback_force)
	queue_free()
