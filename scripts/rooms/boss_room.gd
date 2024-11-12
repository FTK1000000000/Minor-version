extends Node2D
class_name BossRoom


const LEVEL_EXIT = preload("res://interactable/level_exit.tscn")


@onready var root: World = $"../.."
@onready var player_spawn_position: Vector2 = $PlayerSpawnPosition.position
@onready var boss_spawn_position: Vector2 = $BossSpawnPosition.position
@onready var boss_summon: BossSummon = $BossSummon

@export var boss: String
@export var boss_name: String


func _ready() -> void:
	var file = FileAccess.open(Global.BOSS_DATA_PATH, FileAccess.READ)
	var json = file.get_as_text()
	var data = JSON.parse_string(json) as Dictionary
	
	boss_name = data.get(boss).name
	print("[boos spawn] => ",boss_name)


func spawn_boss(boss_path):
	boss_summon.queue_free()
	
	var boss = load(boss_path).instantiate()
	
	var __ = boss.connect("tree_exited", on_boss_killed)
	boss.position = player_spawn_position
	call_deferred("add_child", boss)
	#add_child(boss)

func on_boss_killed():
	var exit = LEVEL_EXIT.instantiate()
	
	exit.position = boss_spawn_position
	add_child(exit)
