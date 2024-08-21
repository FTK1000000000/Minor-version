extends Panel

@onready var background_sprite : Sprite2D = $Background
@onready var item_sprite : Sprite2D = $CenterContainer/Panel/Item
@onready var amount_label : Label = $CenterContainer/Panel/Label

func update(slot : InventorySlot):
	if !slot.item:
		background_sprite.frame = 0
		item_sprite.visible = false
		amount_label.visible = false
	else:
		background_sprite.frame = 1
		item_sprite.visible = true
		item_sprite.texture = slot.item.texture
		if slot.amount > 1:
			amount_label.visible = true
			amount_label.text = str(slot.amount)
