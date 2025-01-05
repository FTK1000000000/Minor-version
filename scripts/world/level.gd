extends World


func _ready() -> void:
	super()
	Global.game_save()
	Global.game_start = true
	GlobalPlayerState.update_ability()
	Global.HUD.show()
	Global.HUD.tips_label.hide()


func _on_button_pressed() -> void:
	#Global.storey_level += 1
	#Global.temporary_ui.add_child(Global.ABILITY_SELECT_PANEL.instantiate())
	Global.load_world("res://world/level.tscn")
