extends Node


const CONFIG_PATH = "user://config.ini"
const SAVE_PATH = "user://save.json"

const SFX_IDX = 1
const BGM_IDX = 2


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bgm_enabled:
	set = set_bgm_enabled, get = is_bgm_enabled
var sfx_enabled:
	set = set_sfx_enabled, get = is_sfx_enabled

var player = preload("res://characters/player/Player.tscn").instantiate()
var player_dead: bool = false
var player_max_health: int = 100
var player_current_health: int
var player_kill: int = 0

var started_at: int = Time.get_unix_time_from_system()
var completed_at: int = Time.get_unix_time_from_system()

@export var room_group_level: int
@export var room_group_index: int


func _ready():
	config_load()
	
	player_current_health = player_max_health


func visibled(node):
	if node.visible:
		node.visible = false
	else:
		node.visible = true

func disabledd(node):
	if !node.disabled:
		node.set_disabled(true)
	else:
		node.set_disabled(false)

func back_to_title():
	room_group_level = 0
	go_to_world("res://ui/title_screen.tscn")

func start_game():
	room_group_level = 0
	started_at = Time.get_unix_time_from_system()
	go_to_world("res://game_scene/main.tscn")

func complete_game():
	room_group_level = 0
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

func config_save():
	var file = ConfigFile.new()
	
	file.set_value("audio", "sfx_enabled", is_sfx_enabled())
	file.set_value("audio", "bgm_enabled", is_bgm_enabled())
	
	file.set_value("audio", "master", SoundManager.get_volume(SoundManager.Bus.MASTER))
	file.set_value("audio", "sfx", SoundManager.get_volume(SoundManager.Bus.SFX))
	file.set_value("audio", "bgm", SoundManager.get_volume(SoundManager.Bus.BGM))
	
	file.save(CONFIG_PATH)

func config_load():
	var file = ConfigFile.new()
	file.load(CONFIG_PATH)
	
	set_bgm_enabled(file.get_value("audio", "bgm_enabled", true))
	set_sfx_enabled(file.get_value("audio", "sfx_enabled", true))
	
	SoundManager.set_volume(
		SoundManager.Bus.MASTER,
		file.get_value("audio", "master", 0.5)
	)
	SoundManager.set_volume(
		SoundManager.Bus.SFX,
		file.get_value("audio", "sfx", 0.5)
	)
	SoundManager.set_volume(
		SoundManager.Bus.BGM,
		file.get_value("audio", "bgm", 0.5)
	)

func game_save():
	var scene: world = get_tree().current_scene
	var scene_name = scene.scene_file_path.get_file().get_basename()
	
	var data = {
		player = {
			max_health = player_max_health,
			current_health = player_current_health
		},
		world = {
			room_group_level = room_group_level,
			room_group_index = scene.room_group_index
		}
	}
	
	var json = JSON.stringify(data)
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file: return
	file.store_string(json)

func game_load():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file: return
	
	var json = file.get_as_text()
	var data = JSON.parse_string(json) as Dictionary
	
	player_max_health = data.player.max_health
	player_current_health = data.player.current_health
	
	go_to_world("res://game_scene/main.tscn")
	var scene = get_tree().current_scene
	room_group_level = data.world.room_group_level
	room_group_index = data.world.room_group_index
	
