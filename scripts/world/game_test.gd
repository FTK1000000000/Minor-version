extends World


func _ready() -> void:
	#GlobalPlayerState.player_classes = "tank"
	GlobalPlayerState.update_classes("mage")
	GlobalPlayerState.spawn_player(self, Vector2(200,200))
	#Global.load_world("res://world/game_test.tscn")
	Global.HUD.show()
	Global.HUD.tips_label.hide()
	
