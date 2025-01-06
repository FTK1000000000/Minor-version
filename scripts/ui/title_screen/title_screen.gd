extends Control


@onready var new_game: Button = $UI/MainMenu/NewGame
@onready var load_game: Button = $UI/MainMenu/LoadGame
@onready var options_menu = $OptionsMenu
@onready var classes_select: Control = $ClassesSelect

@export var bgm: AudioStream


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	if bgm:
		SoundManager.play_bgm(bgm)
	
	new_game.grab_focus()


func _on_new_game_pressed() -> void:
	#Global.new_game()
	classes_select.show()


func _on_load_game_button_pressed() -> void:
	Global.load_game()


func _on_options_button_pressed() -> void:
	options_menu.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_test_pressed() -> void:
	GlobalPlayerState.update_classes("tank")
	Global.storey_level = -1
	Global.load_world("res://world/level.tscn")
	print(Vector2(0, 1)+Vector2(0, -1))
