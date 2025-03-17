extends CanvasLayer


@onready var color_rect: ColorRect = $ColorRect

var level_intensity: Dictionary = {
	0: { "i": 0.0, "o": 0.0, "price": 0 },
	1: { "i": 0.2, "o": 0.2, "price": 10 },
	2: { "i": 0.4, "o": 0.4, "price": 20 }, #ora
	3: { "i": 0.7, "o": 0.7, "price": 30 },
	4: { "i": 1.0, "o": 1.0, "price": 40 }
}
@export var level: int = 0:
	set(v):
		level = v
		update()


func _ready() -> void:
	update(false)


func update(animation: bool = true):
	var iv = level_intensity.get(level).get("i")
	var ov = level_intensity.get(level).get("o")
	if animation:
		create_tween().tween_property(color_rect, "material:shader_parameter/vignette_intensity", iv, 6)
		create_tween().tween_property(color_rect, "material:shader_parameter/vignette_opacity", ov, 6)
	else:
		var shader: ShaderMaterial = color_rect.material
		shader.set_shader_parameter("vignette_intensity", iv)
		shader.set_shader_parameter("vignette_opacity", ov)
