extends StaticBody2D


@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")


func open():
	animation_player.play("open")
