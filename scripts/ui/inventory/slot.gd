extends Button
class_name InventorySlotFromHUD


@onready var item_texture: Sprite2D = $CenterContainer/Panel/Item
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func update(inventory_item: InventoryItem):
	if !inventory_item:
		item_texture.texture = null
	else:
		item_texture.texture = inventory_item.icon

func rand_disappear_position():
	var tex: Texture2D = item_texture.texture
	var pos: Vector2 = Vector2(randi_range(0, tex.get_width()), randi_range(0, tex.get_height()))
	item_texture.material.set_shader_parameter("position", pos)
