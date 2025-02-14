extends World


@onready var button: Button = $HUD/Button


func _on_button_button_up() -> void:
	button.visible = false
	
	Global.is_game_guidance = false
	Global.load_world("res://world/main.tscn")
