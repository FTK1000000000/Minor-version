extends CanvasLayer


@onready var sfx_value: Button = $Control/VBoxContainer/Main/GridContainer/SFXValue
@onready var bgm_value: Button = $Control/VBoxContainer/Main/GridContainer/BGMValue


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	update_button_text()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("back"):
		back()
		get_window().set_input_as_handled()


func update_button_text():
	sfx_value.text = ("on" if Global.sfx_enabled else "off")
	bgm_value.text = ("on" if Global.bgm_enabled else "off")

func back():
	visible = false
	Global.game_keep()

func _on_bgm_pressed() -> void:
	Global.bgm_enabled = not Global.bgm_enabled
	Global.config_save()
	update_button_text()


func _on_sfx_pressed() -> void:
	Global.sfx_enabled = not Global.sfx_enabled
	Global.config_save()
	update_button_text()


func _on_back_pressed() -> void:
	back()


func _on_quit_title_pressed() -> void:
	Global.game_keep()
	Global.go_to_world("res://ui/title_screen.tscn")
