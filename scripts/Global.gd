extends Node2D


const BGM_IDX = 1
const SFX_IDX = 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bgm_enabled:
	set = set_bgm_enabled, get = is_bgm_enabled
var sfx_enabled:
	set = set_sfx_enabled, get = is_sfx_enabled

var player_max_health : int = 100
var player_current_health : int


func _ready():
	player_current_health = player_max_health


func back_to_title():
	go_to_world("res://ui/title_screen.tscn")

func start_game():
	go_to_world("res://world/world.tscn")

func reload_world():
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	
	get_tree().reload_current_scene()
	animation_player.play("fade")

func go_to_world(path):
	get_tree().change_scene_to_file(path)

func is_bgm_enabled():
	return not AudioServer.is_bus_mute(BGM_IDX)

func set_bgm_enabled(value):
	AudioServer.set_bus_mute(BGM_IDX, not value)

func is_sfx_enabled():
	return not AudioServer.is_bus_mute(SFX_IDX)

func set_sfx_enabled(value):
	AudioServer.set_bus_mute(SFX_IDX, not value)
