extends Area2D
class_name Hurtbox


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var parent = get_node("..")


func _ready() -> void:
	gpu_particles_2d.emitting = false


func take_damage(damage: int, direction: Vector2, force: int):
	if parent is Player:
		if GlobalPlayerState.sturdy_shield:
				damage = damage * 0.75 as int
		if parent.is_resist && parent.current_endurance >= damage:
			parent.current_endurance -= damage
			parent.velocity += direction * force
			parent.weapon_node.weapon.effect_player.play("resist")
			parent.endurance_changed.emit()
			parent.is_endurance_disable = true
		
		elif parent.current_endurance < damage:
			parent.current_health -= (damage - parent.current_endurance)
			parent.velocity += direction * force
			parent.state_chart.send_event("hurt")
			parent.is_endurance_disable = true
		
		else:
			parent.current_health -= damage
			parent.velocity += direction * force
			parent.state_chart.send_event("hurt")
			parent.is_endurance_disable = true
	
	elif parent is StaticBody2D:
		parent.current_health -= damage
	
	else:
		parent.current_health -= damage
		parent.velocity += direction * force
		parent.state_chart.send_event("hurt")
	
	var gckf = Global.COMMON_KNOKBACK_FOREC
	gpu_particles_2d.speed_scale = force / gckf if force > gckf else 1
	gpu_particles_2d.rotation = direction.angle()
	gpu_particles_2d.amount = damage
	gpu_particles_2d.restart()
	
	animated_sprite_2d.rotation = direction.angle()
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("default")
	
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.visible = false
