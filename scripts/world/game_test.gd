extends World


func _ready() -> void:
	GlobalPlayerState.player_classes = "tank"
	GlobalPlayerState.spawn_player(self, Vector2(200,200))
	Global.HUD.show()
	Global.HUD.tips_label.hide()
	
