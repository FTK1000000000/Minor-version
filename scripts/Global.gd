extends Node2D


const CONFIG_PATH = "user://settings.cfg"
const BGM_IDX = 1
const SFX_IDX = 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bgm_enabled:
	set = set_bgm_enabled, get = is_bgm_enabled
var sfx_enabled:
	set = set_sfx_enabled, get = is_sfx_enabled

var player: Player = null
var player_dead: bool = false
var player_max_health : int = 100
var player_current_health : int
var player_kill: int = 0

var started_at: int = Time.get_unix_time_from_system()
var completed_at: int = Time.get_unix_time_from_system()


func _ready():
	load_config()
	
	player_current_health = player_max_health


func back_to_title():
	go_to_world("res://ui/title_screen.tscn")

func start_game():
	started_at = Time.get_unix_time_from_system()
	go_to_world("res://world/world.tscn")

func complete_game():
	completed_at = Time.get_unix_time_from_system()
	go_to_world("res://ui/game_complete.tscn")

func reload_world():
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	
	get_tree().reload_current_scene()
	animation_player.play("fade")

func go_to_world(path):
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file(path)
	animation_player.play("fade")

func is_bgm_enabled():
	return not AudioServer.is_bus_mute(BGM_IDX)

func set_bgm_enabled(value):
	AudioServer.set_bus_mute(BGM_IDX, not value)

func is_sfx_enabled():
	return not AudioServer.is_bus_mute(SFX_IDX)

func set_sfx_enabled(value):
	AudioServer.set_bus_mute(SFX_IDX, not value)

func game_pause():
	get_tree().paused = true

func game_keep():
	get_tree().paused = false

func save_config():
	var file = ConfigFile.new()
	file.set_value("audio", "bgm_enabled", is_bgm_enabled())
	file.set_value("audio", "sfx_enabled", is_sfx_enabled())
	var err = file.save(CONFIG_PATH)
	if err != OK:
		push_error("Failed to save config: %d" % err)

func load_config():
	var file = ConfigFile.new()
	var err = file.load(CONFIG_PATH)
	if err == OK:
		set_bgm_enabled(file.get_value("audio", "bgm_enabled", true))
		set_sfx_enabled(file.get_value("audio", "sfx_enabled", true))
	else:
		push_warning("Failed to save config: %d" % err)
		set_bgm_enabled(true)
		set_sfx_enabled(true)
