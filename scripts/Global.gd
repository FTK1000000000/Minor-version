extends Node2D


const BGM_IDX = 1
const SFX_IDX = 2

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

func go_to_world(to):
	pass

func is_bgm_enabled():
	return not AudioServer.is_bus_mute(BGM_IDX)

func set_bgm_enabled(value):
	AudioServer.set_bus_mute(BGM_IDX, not value)

func is_sfx_enabled():
	return not AudioServer.is_bus_mute(SFX_IDX)

func set_sfx_enabled(value):
	AudioServer.set_bus_mute(SFX_IDX, not value)
