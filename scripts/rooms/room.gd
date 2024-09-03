extends Node2D


const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://characters/spawn_expansion.tscn")
const ENEMY_SCENE: Dictionary = {
	"enemy_demo": preload("res://characters/enemy/enemy.tscn"),
	"enemy_demo2": preload("res://characters/enemy/ranged_enemy.tscn")
}

@onready var tile_map: Node2D = get_node("TileMap")
@onready var entrance: Node2D = get_node("Entrance")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")

var num_enemy: int


func _ready() -> void:
	num_enemy = enemy_positions_container.get_child_count()


func on_enemy_killed():
	num_enemy -= 1
	if num_enemy == 0:
		open_doors()

func open_doors():
	for door in door_container.get_children():
		door.open()

func close_entrance():
	for entry_position in entrance.get_children():
		tile_map.get_node("Wall").set_cell(tile_map.get_node("Wall").local_to_map(entry_position.position) + Vector2i(0, 0), 0, Vector2i(1, 0))

func spawn_entity():
	for enemy_positions in enemy_positions_container.get_children():
		var enemy: CharacterBody2D
		if randi() % 2 == 0: enemy = ENEMY_SCENE.enemy_demo.instantiate()
		else: enemy = ENEMY_SCENE.enemy_demo2.instantiate()
		
		var __ = enemy.connect("tree_exited", on_enemy_killed)
		enemy.position = enemy_positions.position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.position = enemy_positions.position
		call_deferred("add_child", spawn_explosion)


func _on_player_detector_body_entered(_body: CharacterBody2D) -> void:
	player_detector.queue_free()
	close_entrance()
	spawn_entity()
