extends Node


const CONFIG_PATH = "user://config.ini"
const SAVE_PATH = "user://save.json"

const CARD_DATA_PATH = "res://card_data.json"
const ENEMY_DATA_PATH = "res://enemy_data.json"
const BOSS_DATA_PATH = "res://boss_data.json"
const NEUTRALITY_DATA_PATH = "res://neutrality_data.json"

const LEVEL_WORLD = "res://world/level.tscn"
const ABILITY_SELECT = preload("res://ui/ability_select/ability_select.tscn")
const CLASSES_SELECT = preload("res://ui/classes_select/classes_select.tscn")

const SFX_IDX = 1
const BGM_IDX = 2

const COMMON_KNOKBACK_FOREC = 500

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var temporary_ui: CanvasLayer
@export var HUD: CanvasLayer

var bgm_enabled: set = set_bgm_enabled, get = is_bgm_enabled
var sfx_enabled: set = set_sfx_enabled, get = is_sfx_enabled
var started_at: int = Time.get_unix_time_from_system()
var completed_at: int = Time.get_unix_time_from_system()

@export var storey_level: int
@export var room_index: int

var game_guidance: bool = true
var game_start: bool = false

var card_data: Dictionary
var enemy_data: Dictionary
var boss_data: Dictionary
var neutrality_data: Dictionary

var boss


func _ready():
	config_load()
	read_card_data()
	read_entity_data()


func back_to_title():
	storey_level = 0
	load_world("res://ui/title_screen.tscn")

func new_game():
	delet_save_date()
	
	storey_level = 0
	started_at = Time.get_unix_time_from_system()
	load_world("res://world/main.tscn")

func complete_game():
	storey_level = 0
	completed_at = Time.get_unix_time_from_system()
	load_world("res://ui/game_complete.tscn")

func load_world(path):
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

func back(node):
	node.visible = false
	game_keep()

func camera_should_shake(amount: float):
	GlobalPlayerState.player.camera.camera_should_shake(amount)

func read_card_data():
	var card = JSON.parse_string(FileAccess.open(CARD_DATA_PATH, FileAccess.READ).get_as_text()) as Dictionary
	card_data = card

func read_entity_data():
	var enemy = JSON.parse_string(FileAccess.open(ENEMY_DATA_PATH, FileAccess.READ).get_as_text()) as Dictionary
	var boss = JSON.parse_string(FileAccess.open(BOSS_DATA_PATH, FileAccess.READ).get_as_text()) as Dictionary
	var neutrality = JSON.parse_string(FileAccess.open(NEUTRALITY_DATA_PATH, FileAccess.READ).get_as_text()) as Dictionary
	enemy_data = enemy
	boss_data = boss
	neutrality_data = neutrality

func config_save():
	var file = ConfigFile.new()
	
	file.set_value("audio", "sfx_enabled", is_sfx_enabled())
	file.set_value("audio", "bgm_enabled", is_bgm_enabled())
	
	file.set_value("audio", "master", SoundManager.get_volume(SoundManager.BUS.MASTER))
	file.set_value("audio", "sfx", SoundManager.get_volume(SoundManager.BUS.SFX))
	file.set_value("audio", "bgm", SoundManager.get_volume(SoundManager.BUS.BGM))
	
	file.save(CONFIG_PATH)

func config_load():
	var file = ConfigFile.new()
	file.load(CONFIG_PATH)
	
	set_bgm_enabled(file.get_value("audio", "bgm_enabled", true))
	set_sfx_enabled(file.get_value("audio", "sfx_enabled", true))
	
	SoundManager.set_volume(
		SoundManager.BUS.MASTER,
		file.get_value("audio", "master", 0.5)
	)
	SoundManager.set_volume(
		SoundManager.BUS.SFX,
		file.get_value("audio", "sfx", 0.5)
	)
	SoundManager.set_volume(
		SoundManager.BUS.BGM,
		file.get_value("audio", "bgm", 0.5)
	)

func game_save():
	var scene: World = get_tree().current_scene
	var g = GlobalPlayerState
	var ga = GlobalPlayerState.player_ability
	
	if ga.has("more_health"): g.player_max_health = (g.player_max_health - ga.count("more_health") * 50)
	if ga.has("more_endurance"): g.player_max_endurance = (g.player_max_endurance - ga.count("more_endurance") * 50)
	if ga.has("more_walk_speed"): g.player_walk_move_speed = (g.player_walk_move_speed - ga.count("more_walk_speed") * 50)
	if ga.has("more_run_speed"): g.player_run_move_speed = (g.player_run_move_speed - ga.count("more_run_speed") * 50)
	
	var data = {
		game = {
			game_guidance = game_guidance
		},
		ability_list = g,
		player = {
			classes = g.player_classes,
			weapon = g.player_weapon,
			walk_move_speed = g.player_walk_move_speed,
			run_move_speed = g.player_run_move_speed,
			max_health = g.player_max_health,
			max_endurance = g.player_max_endurance,
			current_health = g.player_current_health,
			ability = g.player_ability,
			remainder_ability = g.remainder_ability,
			kill = g.player_kill
		},
		world = {
			storey_level = storey_level,
			room_index = room_index
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
	if json == "": return
	var data = JSON.parse_string(json) as Dictionary
	
	var g = GlobalPlayerState
	
	game_guidance = data.game.game_guidance
	
	g.player_classes = data.player.classes
	g.player_weapon = data.player.weapon
	g.player_max_health = data.player.max_health
	g.player_max_endurance = data.player.max_endurance
	g.player_current_health = data.player.current_health
	g.player_ability = data.player.ability
	g.remainder_ability = data.player.remainder_ability
	g.player_kill = data.player.kill
	
	g.update_ability()
	load_world("res://world/level.tscn")
	var scene = get_tree().current_scene
	storey_level = data.world.storey_level
	room_index = data.world.room_index

func delet_save_date():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if not file: return
	file.store_string("")
