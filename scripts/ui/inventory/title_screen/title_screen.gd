extends Control


@onready var options_menu = $OptionsMenu
@onready var world = preload("res://world/world.tscn")
@onready var mouse_entered_sound: AudioStreamPlayer2D = $MouseEnteredSound
@onready var click_sound: AudioStreamPlayer2D = $ClickSound


func _ready() -> void:
	hook_button_sound(self)


func hook_button_sound(node):
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(mouse_entered_sound.play)
			child.pressed.connect(click_sound.play)
		else:
			hook_button_sound(child)


func _on_new_game_pressed() -> void:
	get_tree()


func _on_load_game_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	options_menu.visible = true


func _on_quit_button_pressed() -> void:
	get_tree().quit()
