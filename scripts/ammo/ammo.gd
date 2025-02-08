extends Hitbox
class_name Ammo


const HIT_EXPLOSION_SCENE: PackedScene = preload("res://character/spawn_expansion.tscn")


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var collision_exited: bool = false
@export var fly_speed: int = 200
@export var life_cycle: float = 5
@export var hit_piercing: int = 0
var piercing_amount: int = 0


func _ready() -> void:
	dead()

func _physics_process(delta: float) -> void:
	position += knockback_direction * fly_speed * delta

func hit(area: Hurtbox):
	if area == Resistbox:
		if GlobalPlayerState.sturdy_shield:
			queue_free()
	
	var hit_explosion_scene = HIT_EXPLOSION_SCENE.instantiate()
	area.add_child(hit_explosion_scene)
	hit_explosion_scene.position = position
	
	area.take_damage(damage_type, damage, knockback_direction, knockback_force)
	give_effect(area.owner)
	
	if hit_piercing < 0:
		return
	else:
		if piercing_amount < hit_piercing:
			piercing_amount += 1
		else:
			queue_free()


func dead():
	await get_tree().create_timer(life_cycle).timeout
	
	queue_free()

func launch(initial_position: Vector2, dir: Vector2, speed: int):
	position = initial_position
	rotation = dir.angle()
	knockback_direction = dir
	fly_speed = speed if speed else fly_speed


func _on_area_exited(area: Hurtbox) -> void:
	super(area)
	collision_ready = true
	print(target_group)


func _on_body_entered(body: TileMapLayer) -> void:
	var hit_explosion_scene = HIT_EXPLOSION_SCENE.instantiate()
	body.add_child(hit_explosion_scene)
	hit_explosion_scene.position = position
	
	queue_free()
