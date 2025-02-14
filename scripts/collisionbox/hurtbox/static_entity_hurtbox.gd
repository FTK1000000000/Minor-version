extends Hurtbox
class_name StaticEntityHurtbox


func take_damage(type: String, damage: int, direction: Vector2 = Vector2.ZERO, force: int = 0):
	if owner.is_dead: return
	var tex: Texture2D = target.body_texture.texture
	var color: Color = tex.get_image().get_pixel(tex.get_height() / 2, tex.get_width() / 2)
	hurt_particles.process_material.color = color
	dead_particles.process_material.color = color
	
	if damage < target.current_health:
		target.set_current_health(target.current_health - damage)
		target.hurting.emit()
		bleed(damage, direction, force)
		#mark(damage, direction, force)
	else:
		target.deading.emit()
		explode(damage, direction, force)
