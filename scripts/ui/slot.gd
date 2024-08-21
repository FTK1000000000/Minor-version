extends Button

@onready var background_sprite : Sprite2D = $Background
@onready var container : CenterContainer = $CenterContainer

var items_stack : ItemsStack

func insert(isg : ItemsStack):
	items_stack = isg
	background_sprite.frame = 1
	container.add_child(items_stack)
