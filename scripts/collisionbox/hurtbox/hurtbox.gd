extends Area2D
class_name Hurtbox


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_particles: GPUParticles2D = $HurtParticles
@onready var dead_particles: GPUParticles2D = $DeadParticles
@onready var target = get_node("..")

var is_ready: bool = true


func ready_time():
	is_ready = false
	await get_tree().create_timer(target.hurt_ready_time).timeout
	
	is_ready = true

func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	if owner.is_dead: return
	if target is static_entity:
		target.current_health -= damage
	
	if damage < target.current_health:
		target.current_health(target.current_health - damage)
		target.velocity += direction * force
		target.hurt.emit()
		
		mark(damage, direction, force)
		ready_time()
	else:
		target.current_health(0)
		target.velocity += direction * force
		target.hurt.emit()
		target.dead.emit()
		
		explode(damage, direction, force)

func bleed(damage: int, direction: Vector2, force: int):
	if direction == Vector2.ZERO:
		direction = Vector2(randi_range(-10, 10), randi_range(-10, 10))
	var ckf = Common.knokback_forec
	hurt_particles.speed_scale = force / ckf if force > ckf else 1
	hurt_particles.rotation = direction.angle()
	hurt_particles.amount = damage
	hurt_particles.restart()

func jitter(damage: int, direction: Vector2, force: int):
	var skew_transform = func():
		var pbt = target.body_texture
		var ov = pbt.skew
		var v = direction.angle()
		
		create_tween().tween_property(pbt, "skew", v, Common.hurt_blink_time)
		
		await create_tween().tween_property(pbt, "skew", v, Common.hurt_blink_time)
		create_tween().tween_property(pbt, "skew", ov, Common.hurt_blink_time)
	var offset_transform = func():
		var pbt = target.body_texture
		var ov = pbt.offset
		var v = 16
		
		create_tween().tween_property(pbt, "offset", v, Common.hurt_blink_time)
		
		await create_tween().tween_property(pbt, "offset", v, Common.hurt_blink_time)
		create_tween().tween_property(pbt, "offset", ov, Common.hurt_blink_time)
	skew_transform.call()
	offset_transform.call()

func mark(damage: int, direction: Vector2, force: int):
	if direction == Vector2.ZERO:
		direction = Vector2(randi_range(-10, 10), randi_range(-10, 10))
	animated_sprite_2d.rotation = direction.angle()
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("default")
	
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.visible = false

func explode(damage: int, direction: Vector2, force: int):
	var ckf = Common.knokback_forec
	dead_particles.speed_scale = force / ckf if force > ckf else 1
	dead_particles.amount = damage * 2
	dead_particles.restart()
