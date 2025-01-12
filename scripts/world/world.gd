extends Node2D
class_name World


@onready var temporary_ui: CanvasLayer = $TemporaryUI
@onready var hud: CanvasLayer = $HUD
@onready var player: Player

@export var bgm: AudioStream


func _ready() -> void:
	if bgm:
		SoundManager.play_bgm(bgm)
	
	Global.world = self
	Global.temporary_ui = temporary_ui
	Global.HUD = hud
	
	GlobalPlayerState.spawn_player(self)
