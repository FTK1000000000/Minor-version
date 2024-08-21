extends Node2D

var player_max_health : int = 100
var player_current_health : int

func _ready():
	player_current_health = player_max_health
