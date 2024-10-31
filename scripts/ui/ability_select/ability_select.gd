extends Control


@onready var ability_option_slot: Button = $Panel/VBoxContainer/HBoxContainer/AbilityOptionSlot


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	ability_option_slot.grab_focus()
	Global.game_pause()


func _on_ability_option_slot_button_up() -> void:
	Global.HUD.show()
	Global.game_keep()
	Global.load_world(Global.LEVEL_WORLD)
	
	queue_free()
