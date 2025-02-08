extends Area2D
class_name Hitbox


@export var collision_ready: bool = true
@export var target_group: Array[Hurtbox]
#@export var target: Hurtbox = null

@export var effects: Array[Dictionary]
@export var damage_type: String = "none"
@export var damage: int = 10
@export var knockback_force: int = 300
@export var knockback_direction: Vector2 = Vector2.ZERO
@export var ready_time: float = 1

@onready var parent = get_node("..")


func _process(delta: float) -> void:
	if collision_ready && target_group.size() != 0:
		for target in target_group:
			if target.is_ready:
				hit(target)
		collision_ready = false
		
		await get_tree().create_timer(ready_time).timeout
		collision_ready = true


func hit(area: Hurtbox):
	knockback_direction = (area.global_position - global_position).normalized()
	area.take_damage(damage_type, damage, knockback_direction, knockback_force)
	give_effect(area.owner)

func give_effect(target: Entity):
	if !effects.is_empty():
		for effect in effects:
			var effect_machine: EffectMachine = target.effect_machine
			effect_machine.add_effect(effect.data_name, effect.time as float)


func _on_area_entered(area: Hurtbox) -> void:
	target_group.push_back(area)


func _on_area_exited(area: Hurtbox) -> void:
	target_group.erase(area)
