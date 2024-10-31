extends Control


@onready var classes_option_slot: Button = $Panel/HBoxContainer/ClassesOptionSlot


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	classes_option_slot.grab_focus()
	Global.game_pause()


func _on_classes_option_slot_button_up() -> void:
	Global.HUD.show()
	Global.game_keep()
	
	queue_free()
