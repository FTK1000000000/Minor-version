extends World


func _ready() -> void:
	GlobalPlayerState.update_classes("tank")
	super()
	Global.HUD.tips_label.hide()
	GlobalPlayerState.player.global_position = Vector2(200, 200)
