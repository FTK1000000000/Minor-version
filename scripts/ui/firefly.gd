extends GPUParticles2D


func _ready() -> void:
	update()


func update():
	var position: Vector2 = Vector2(
			ProjectSettings.get_setting("display/window/size/viewport_width") / 2,
			ProjectSettings.get_setting("display/window/size/viewport_height") / 2
	)
	var box_range: Vector3 = Vector3(
			ProjectSettings.get_setting("display/window/size/viewport_width") / 2,
			ProjectSettings.get_setting("display/window/size/viewport_height") / 2,
			0
	)
	position = position
	process_material.emission_box_extents = box_range
