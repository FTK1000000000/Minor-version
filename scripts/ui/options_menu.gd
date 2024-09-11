extends CanvasLayer


@onready var bgm: Button = $VBoxContainer/BGM
@onready var sfx: Button = $VBoxContainer/SFX


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	update_button_text()


func update_button_text():
	bgm.text = "bgm:" + ("on" if Global.bgm_enabled else "off")
	sfx.text = "sfx:" + ("on" if Global.sfx_enabled else "off")


func _on_bgm_pressed() -> void:
	Global.bgm_enabled = not Global.bgm_enabled
	Global.save_config()
	update_button_text()


func _on_sfx_pressed() -> void:
	Global.sfx_enabled = not Global.sfx_enabled
	Global.save_config()
	update_button_text()


func _on_back_pressed() -> void:
	visible = false


func _on_quit_title_pressed() -> void:
	Global.go_to_world("res://ui/title_screen.tscn")
