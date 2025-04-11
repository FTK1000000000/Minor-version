extends Node2D
class_name World


@onready var temporary_ui: CanvasLayer = $TemporaryUI
@onready var hud: CanvasLayer = $HUD

@export var bgm: AudioStream


func _ready() -> void:
	if bgm:
		SoundManager.play_bgm(bgm)
	
	Global.world = self
	Global.temporary_ui = temporary_ui
	Global.HUD = hud
	GlobalPlayerState.spawn_player(self)
	GlobalPlayerState.player.firefly.restart()


func _on_next_button_up() -> void:
	Global.storey_level += 1
	Global.load_world("res://world/level.tscn")


func _on_reload_button_up() -> void:
	Global.load_world("res://world/level.tscn")


func _on_get_ability_button_up() -> void:
	Global.temporary_ui.add_child(Global.ABILITY_SELECT_PANEL.instantiate())


func _on_change_classes_button_up() -> void:
	var a = GlobalPlayerState.player_classes
	a = ("hunter" if a=="tank" else ("mage" if a=="hunter" else "tank"))
	GlobalPlayerState.update_classes(a)


#func _on_def_deck_button_up() -> void:
	#Global.deck.draw_pile + cards


func _on_spawn_event_button_up() -> void:
	Global.event_control.spawn_event_ui()
