extends World


@onready var rooms_generator: Node2D = $RoomsGenerator


func _ready() -> void:
	super()
	Global.game_save()
	Global.is_game_start = true
	GlobalPlayerState.update_ability()
	Global.HUD.show()
	Global.HUD.tips_label.hide()
	rooms_generator.run()


func _on_next_button_up() -> void:
	Global.storey_level += 1
	Global.load_world("res://world/level.tscn")


func _on_reload_button_up() -> void:
	Global.load_world("res://world/level.tscn")


func _on_get_ability_button_up() -> void:
	Global.temporary_ui.add_child(Global.ABILITY_SELECT_PANEL.instantiate())


func _on_change_classes_button_up() -> void:
	var a = GlobalPlayerState.player_classes
	a = ("hunter" if a=="tank" else ("mage" if a=="hunter" else "tank"))
	GlobalPlayerState.update_classes(a)
