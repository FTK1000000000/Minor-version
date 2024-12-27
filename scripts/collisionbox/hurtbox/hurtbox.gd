extends Area2D
class_name Hurtbox


const COMMON_HURT_BLINK_TIME = 0.3


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_particles: GPUParticles2D = $HurtParticles
@onready var dead_particles: GPUParticles2D = $DeadParticles
@onready var parent = get_node("..")


func take_damage(damage: int, direction: Vector2, force: int):
	if parent is StaticBody2D:
		parent.current_health -= damage
	
	if damage < parent.current_health:
		parent.current_health -= damage
		parent.velocity += direction * force
		parent.hurt.emit()
		
		mark(damage, direction, force)
	else:
		parent.dead.emit()

func bleed(damage: int, direction: Vector2, force: int):
	var ckf = Common.KNOKBACK_FOREC
	hurt_particles.speed_scale = force / ckf if force > ckf else 1
	hurt_particles.rotation = direction.angle()
	hurt_particles.amount = damage
	hurt_particles.restart()

func jitter(damage: int, direction: Vector2, force: int):
	var skew_transform = func():
		var pbt = parent.body_texture
		var ov = pbt.skew
		var v = direction.angle()
		
		create_tween().tween_property(pbt, "skew", v, COMMON_HURT_BLINK_TIME)
		
		await create_tween().tween_property(pbt, "skew", v, COMMON_HURT_BLINK_TIME)
		create_tween().tween_property(pbt, "skew", ov, COMMON_HURT_BLINK_TIME)
	var offset_transform = func():
		var pbt = parent.body_texture
		var ov = pbt.offset
		var v = 16
		
		create_tween().tween_property(pbt, "offset", v, COMMON_HURT_BLINK_TIME)
		
		await create_tween().tween_property(pbt, "offset", v, COMMON_HURT_BLINK_TIME)
		create_tween().tween_property(pbt, "offset", ov, COMMON_HURT_BLINK_TIME)
	skew_transform.call()
	offset_transform.call()

func mark(damage: int, direction: Vector2, force: int):
	animated_sprite_2d.rotation = direction.angle()
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("default")
	
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.visible = false

func explode(damage: int, direction: Vector2, force: int):
	var ckf = Common.KNOKBACK_FOREC
	dead_particles.speed_scale = force / ckf if force > ckf else 1
	dead_particles.amount = damage * 2
	dead_particles.restart()
