extends Card


#func effect():
	#collision_of_hit(64, self.global_position)


#func collision_of_hit(radius, position):
	#var shape_cicle = CircleShape2D.new()
	#shape_cicle.radius = radius
	#
	#var p = PhysicsShapeQueryParameters2D.new()
	#p.set_shape(shape_cicle)
	#p.collide_with_areas = true
	#p.collision_mask = 6
	#p.transform = Transform2D(0, position)
	#
	## 检测碰撞
	#var v = get_world_2d().direct_space_state.intersect_shape(p)
	#
	#for i in v:
		#var collisionbox = i.collider
		#print(collisionbox)

func ability():
	pass
