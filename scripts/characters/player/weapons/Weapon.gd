extends Node2D


@onready var textruse = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_ready_timer = $WeaponAttackReadyTimer
@onready var hitbox: Hitbox = $Hitbox
@onready var collision = $Hitbox/CollisionShape2D
