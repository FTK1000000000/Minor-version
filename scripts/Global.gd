extends Node2D


const CONFIG_PATH = "user://config.ini"
const SFX_IDX = 1
const BGM_IDX = 2

#const SAVE_PATH = "user://data.sav"

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var bgm_enabled:
	set = set_bgm_enabled, get = is_bgm_enabled
var sfx_enabled:
	set = set_sfx_enabled, get = is_sfx_enabled

var world_states: Dictionary = {}

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
	var config = ConfigFile.new()
	
	config.set_value("audio", "sfx_enabled", is_sfx_enabled())
	config.set_value("audio", "bgm_enabled", is_bgm_enabled())
	
	config.set_value("audio", "master", SoundManager.get_volume(SoundManager.Bus.MASTER))
	config.set_value("audio", "sfx", SoundManager.get_volume(SoundManager.Bus.SFX))
	config.set_value("audio", "bgm", SoundManager.get_volume(SoundManager.Bus.BGM))
	
	config.save(CONFIG_PATH)

func load_config():
	var config = ConfigFile.new()
	config.load(CONFIG_PATH)
	
	set_bgm_enabled(config.get_value("audio", "bgm_enabled", true))
	set_sfx_enabled(config.get_value("audio", "sfx_enabled", true))
	
	SoundManager.set_volume(
		SoundManager.Bus.MASTER,
		config.get_value("audio", "master", 0.5)
	)
	SoundManager.set_volume(
		SoundManager.Bus.SFX,
		config.get_value("audio", "sfx", 0.5)
	)
	SoundManager.set_volume(
		SoundManager.Bus.BGM,
		config.get_value("audio", "bgm", 0.5)
	)

#func change_screen(path: String, params: Dictionary = {}):
	#var tree = get_tree()
	#
	#var old_name = tree.current_scene.scene_file_path.get_file().get_basename()
	#world_states[old_name] = tree.current_scene.to_dict()
	#
	#tree.change_scene_to_file(path)
	#await tree.tree_changed
	#
	#var new_name = tree.current_scene.scene_file_path.get_file().get_basename()
	#if new_name in world_states:
		#tree.current_scene.from_dict(world_states[new_name])
	#
	#if "position" in params:
		#tree.current_scene.update_player(params.position)

#func save_game():
	#var scene = get_tree().current_scene
	#var scene_name = scene.scene_file_path.get_file().get_basename()
	#world_states[scene_name] = scene.to_dict()
	#
	#var data = {
		#world_states = world_states,
		#stats = player.to_dict(),
		#scene = scene.scene_file_path,
		#player = {
			#position = {
				#x = scene.player.global_position.x,
				#y = scene.player.global_position.y,
			#}
		#}
	#}
	#var json = JSON.stringify(data)
	#var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	#if not file:
		#return
	#file.store_string(json)

#func load_game():
	#var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	#if not file:
		#return
	#
	#var json = file.get_as_text()
	#var data = JSON.parse_string(json) as Dictionary
	#
	#world_states = data.world_states
	#player.from_dict(data.stats)
	#
	#change_screen(data.scene, {
		#position = Vector2(
			#data.player.position.x,
			#data.player.position.y,
		#)
	#})
