extends Hurtbox
class_name StaticEntityHurtbox


func take_damage(damage: int, direction: Vector2, force: int):
	var tex: Texture2D = parent.body_texture.texture
	var color: Color = tex.get_image().get_pixel(tex.get_height() / 2, tex.get_width() / 2)
	hurt_particles.process_material.color = color
	dead_particles.process_material.color = color
	
	if damage < parent.current_health:
		parent.current_health -= damage
		parent.hurting.emit()
		
		bleed(damage, direction, force)
		mark(damage, direction, force)
	else:
		parent.deading.emit()
		
		explode(damage, direction, force)
