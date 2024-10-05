extends Node2D
class_name Weapon


@onready var hitbox: Hitbox = $Hitbox
@onready var collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var textruse: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_ready_timer: Timer = $AttackReadyTimer
@onready var charge_attack_ready_timer: Timer = $ChargeAttackReadyTimer

@export var hit_damage: int = 10
@export var hit_ready_time: float = 0.1


func _ready() -> void:
	hitbox.damage = hit_damage
	hitbox.ready_time = hit_ready_time


func special_attack():
	pass
