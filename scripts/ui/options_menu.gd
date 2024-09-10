extends CanvasLayer


@onready var bgm: Button = $VBoxContainer/BGM
@onready var sfx: Button = $VBoxContainer/SFX

@onready var mouse_entered_sound: AudioStreamPlayer2D = $MouseEnteredSound
@onready var click_sound: AudioStreamPlayer2D = $ClickSound


func _ready() -> void:
	hook_button_sound(self)
	update_button_text()


func hook_button_sound(node):
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(mouse_entered_sound.play)
			child.pressed.connect(click_sound.play)
		else:
			hook_button_sound(child)

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
