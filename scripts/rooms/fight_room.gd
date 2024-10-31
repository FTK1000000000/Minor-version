extends Node2D


const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://characters/spawn_expansion.tscn")
const ENEMY_SCENE: Dictionary = {
	"enemy_demo": preload("res://characters/enemy/goblin.tscn"),
	"enemy_demo2": preload("res://characters/enemy/ranged_enemy.tscn")
}

@onready var tile_map: Node2D = get_node("TileMap")
@onready var tile_floor: Node2D = get_node("TileMap/Floor")
@onready var tile_wall: Node2D = get_node("TileMap/Wall")
@onready var door_container: Node2D = get_node("Doors")
@onready var enemy_positions_container: Node2D = get_node("EnemyPositions")
@onready var player_detector: Area2D = get_node("PlayerDetector")

var num_enemy: int


func _ready() -> void:	
	open_doors()
	num_enemy = enemy_positions_container.get_child_count()


func on_enemy_killed():
	num_enemy -= 1
	if num_enemy == 0:
		open_doors()

func open_doors():
	for door in door_container.get_children():
		door.open()

func close_doors():
	for door in door_container.get_children():
		door.close()

func spawn_entity():
	for enemy_positions in enemy_positions_container.get_children():
		var enemy: Enemy
		if randi() % 2 == 0: enemy = ENEMY_SCENE.enemy_demo.instantiate()
		else: enemy = ENEMY_SCENE.enemy_demo2.instantiate()
		
		var __ = enemy.connect("tree_exited", on_enemy_killed)
		enemy.position = enemy_positions.position
		call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.position = enemy_positions.position
		call_deferred("add_child", spawn_explosion)


func _on_player_detector_body_entered(_body: Player) -> void:
	player_detector.queue_free()
	close_doors()
	spawn_entity()
