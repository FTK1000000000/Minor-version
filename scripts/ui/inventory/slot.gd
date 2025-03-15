extends Button
class_name InventorySlotFromHUD


const TEST_ICON = preload("res://texture/card/test.png")


@onready var item_texture: Sprite2D = $CenterContainer/Panel/Item
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var playing: bool = false


func update(inventory_item: InventoryItem):
	if !inventory_item:
		item_texture.texture = TEST_ICON
	else:
		item_texture.texture = inventory_item.icon

func rand_disappear_position():
	var pos: Vector2 = Vector2(randf_range(0, 1), randf_range(0, 1))
	var shader: ShaderMaterial = item_texture.material
	shader.set_shader_parameter("position", pos)

func play():
	animation_player.play("play")
