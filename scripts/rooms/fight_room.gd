extends Node2D


const SPAWN_EXPLOSION_SCENE: PackedScene = preload("res://character/spawn_expansion.tscn")
const ENEMY_SCENE: Dictionary = {
	"enemy_demo": preload("res://character/entity/enemy/goblin.tscn"),
	"enemy_demo2": preload("res://character/entity/enemy/goblin_bowman.tscn")
}

enum TILE_LAYER {
	FLOOR = 1,
	WALL,
	FLOORO,
	WALLO,
	WALL_HEAD
}


@onready var root: Node2D = get_parent()
@onready var tile_map: Node2D = get_node("TileMap")
@onready var tile_floor: Node2D = get_node("TileMap/Floor")
@onready var tile_wall: Node2D = get_node("TileMap/Wall")
@onready var door_container: Node2D = get_node("Doors")
@onready var player_detector: Area2D = get_node("PlayerDetector")
@onready var enemys: Node2D = $Enemys

var enemys_price: int
var enemy_amount: int
var enemy_group_data: Array
var has_spawn_enemy: bool = false


func _ready() -> void:
	open_doors()


func on_enemy_killed():
	enemy_amount -= 1
	if enemy_amount <= 0:
		open_doors()

func open_doors():
	for door in door_container.get_children():
		door.open()

func close_doors():
	for door in door_container.get_children():
		door.close()

func spawn_entity():
	#read
	enemy_group_data = root.room_enemy_group_data.pop_front()
	print("[enemy_generator] => enemy_group_data: ", enemy_group_data)
	
	#spawn
	while enemy_group_data.size() != 0:
		var enemy: Enemy
		var spawn_position: Vector2i
		var floor_layer: Array = tile_map.get_child(TILE_LAYER.FLOOR).get_used_cells()
		spawn_position = floor_layer[randi() % floor_layer.size()] * Common.TILE_SIZE
		spawn_position = (spawn_position + Vector2i.LEFT if spawn_position.x < 0 else spawn_position + Vector2i.RIGHT)
		spawn_position = (spawn_position + Vector2i.UP if spawn_position.y < 0 else spawn_position + Vector2i.DOWN)
		enemy = load(enemy_group_data.pop_front()).instantiate()
		enemy.position = spawn_position
		enemy.connect("tree_exited", on_enemy_killed)
		enemys.call_deferred("add_child", enemy)
		
		var spawn_explosion: AnimatedSprite2D = SPAWN_EXPLOSION_SCENE.instantiate()
		spawn_explosion.position = enemy.position
		enemys.call_deferred("add_child", spawn_explosion)
		enemy_amount += 1
		print("/[spawn_enemy] => enemy:", str(enemy), " spawn_position: ", spawn_position)
	has_spawn_enemy = true
	


func _on_player_detector_body_entered(_body: Player) -> void:
	player_detector.queue_free()
	close_doors()
	spawn_entity()
