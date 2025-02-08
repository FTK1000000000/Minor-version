extends Area2D
class_name Hurtbox


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_particles: GPUParticles2D = $HurtParticles
@onready var dead_particles: GPUParticles2D = $DeadParticles
@onready var parent = get_node("..")

var is_ready: bool = true


func ready_time():
	is_ready = false
	await get_tree().create_timer(parent.hurt_ready_time).timeout
	
	is_ready = true

func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	if parent is StaticBody2D:
		parent.current_health -= damage
	
	if damage < parent.current_health:
		parent.current_health -= damage
		parent.velocity += direction * force
		parent.hurt.emit()
		
		mark(damage, direction, force)
		ready_time()
	else:
		parent.current_health = 0
		parent.velocity += direction * force
		parent.hurt.emit()
		parent.dead.emit()
		
		explode(damage, direction, force)

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
		
		create_tween().tween_property(pbt, "skew", v, Common.HURT_BLINK_TIME)
		
		await create_tween().tween_property(pbt, "skew", v, Common.HURT_BLINK_TIME)
		create_tween().tween_property(pbt, "skew", ov, Common.HURT_BLINK_TIME)
	var offset_transform = func():
		var pbt = parent.body_texture
		var ov = pbt.offset
		var v = 16
		
		create_tween().tween_property(pbt, "offset", v, Common.HURT_BLINK_TIME)
		
		await create_tween().tween_property(pbt, "offset", v, Common.HURT_BLINK_TIME)
		create_tween().tween_property(pbt, "offset", ov, Common.HURT_BLINK_TIME)
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
