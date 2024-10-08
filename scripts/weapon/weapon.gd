extends Node2D
class_name Weapon


@onready var player: Player = $"../.."
@onready var hitbox: Hitbox = $Hitbox
@onready var collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var effect_player: AnimationPlayer = $EffectPlayer
@onready var textruse: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_ready_timer: Timer = $AttackReadyTimer
@onready var charge_attack_ready_timer: Timer = $ChargeAttackReadyTimer

@export var attack_consume_endurance: int = 20
@export var special_attack_consume_endurance: int = 40

@export var hit_damage: int = 10
@export var hit_ready_time: float = 0.1

@export var max_charge: int = 10
@export var need_charge: int = 3
@export var current_charge: int = 0

@export var is_special_charge: bool = false


func _ready() -> void:
	hitbox.damage = hit_damage
	hitbox.ready_time = hit_ready_time


func special_attack():
	pass

func charge_timer():
	if charge_attack_ready_timer.is_stopped():
		charge_attack_ready_timer.start()
		await charge_attack_ready_timer.timeout
		
		current_charge += 1
		print("current_charge: ", current_charge)
		if current_charge >= max_charge || !is_special_charge:
			return
		charge_timer()

func charge_comlete():
	player.is_endurance_disable = false
	is_special_charge = false
	current_charge = 0
	animation_player.play("charge_complete")
