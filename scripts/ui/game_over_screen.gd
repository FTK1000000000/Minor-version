extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _input(event: InputEvent) -> void:
	if visible && event.is_action_pressed("select"):
		#if Global.has_save():
			#Global.load_game()
		#else:
			Global.back_to_title()


func game_over():
	show()
	animation_player.play("enter")
