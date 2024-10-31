extends Control


@onready var new_game: Button = $UI/MainMenu/NewGame
@onready var load_game: Button = $UI/MainMenu/LoadGame
@onready var options_menu = $OptionsMenu
@onready var error: Label = $Error

var error_life_time: float = 1.6

@export var bgm: AudioStream


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	if bgm:
		SoundManager.play_bgm(bgm)
	
	new_game.grab_focus()


func _on_new_game_pressed() -> void:
	Global.new_game()


func _on_load_game_button_pressed() -> void:
	var save_file = FileAccess.open("user://save.json", FileAccess.READ)
	if !save_file:
		await get_tree().create_timer(0.2).timeout
		
		error.text = "not have save file"
		await get_tree().create_timer(error_life_time).timeout
		
		error.text = ""
	else:
		Global.game_load()


func _on_options_button_pressed() -> void:
	options_menu.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()
