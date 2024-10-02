extends Control


@onready var options_menu = $OptionsMenu
@onready var error: Label = $Error

var error_life_time: float = 1.6

@export var bgm: AudioStream


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	
	if bgm:
		SoundManager.play_bgm(bgm)


func _on_new_game_pressed() -> void:
	Global.start_game()


func _on_load_game_button_pressed() -> void:
	#error.text = "Save is not supported"
	#await get_tree().create_timer(error_life_time).timeout
	
	Global.game_load()


func _on_options_button_pressed() -> void:
	options_menu.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()
