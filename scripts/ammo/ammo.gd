extends Hitbox
class_name Ammo


const HIT_EXPLOSION_SCENE: PackedScene = preload("res://characters/spawn_expansion.tscn")


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var collision_exited: bool = false

@export var direction: Vector2 = Vector2.ZERO
@export var knife_speed: int
@export var life_cycle: float = 5


func _ready() -> void:
	dead()

func _physics_process(delta: float) -> void:
	position += direction * knife_speed * delta


func dead():
	await get_tree().create_timer(life_cycle).timeout
	queue_free()

func launch(initial_position: Vector2, dir: Vector2, speed: int):
	position = initial_position
	rotation = dir.angle()
	direction = dir
	knockback_direction = dir
	knife_speed = speed


func _on_area_entered(area: Area2D) -> void:
	var hit_explosion_scene = HIT_EXPLOSION_SCENE.instantiate()
	area.add_child(hit_explosion_scene)
	hit_explosion_scene.position = position
	
	area.take_damage(damage, knockback_direction, knockback_force)
	
	queue_free()


func _on_body_entered(body: TileMapLayer) -> void:
	var hit_explosion_scene = HIT_EXPLOSION_SCENE.instantiate()
	body.add_child(hit_explosion_scene)
	hit_explosion_scene.position = position
	
	queue_free()
