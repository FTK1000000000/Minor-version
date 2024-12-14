extends Node2D


const HOME = preload("res://rooms/home.tscn")
const HOME_GUIDANCE = preload("res://rooms/home_guidance.tscn")


@onready var hud: CanvasLayer = $"../HUD"
@onready var button: Button = $"../HUD/Button"
@onready var player: Player = $"../Player"


func _ready() -> void:
	spawn_rooms()


func spawn_rooms():
	var room
	
	if Global.game_guidance:
		button.visible = true
		room = HOME_GUIDANCE.instantiate()
	else:
		button.visible = false
		room = HOME.instantiate()
	
	add_child(room)
	
	var player_spawn_position = room.from_room.player_spawn_position
	player.position = player_spawn_position
