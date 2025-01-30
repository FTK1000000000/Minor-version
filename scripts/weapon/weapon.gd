extends Node2D
class_name Weapon


@onready var player: Player = GlobalPlayerState.player
@onready var hitbox: Hitbox = $Hitbox
@onready var hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var effect_player: AnimationPlayer = $EffectPlayer
@onready var textruse: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_ready_timer: Timer = $AttackReadyTimer
@onready var charge_attack_ready_timer: Timer = $ChargeAttackReadyTimer

@export var data_name: String
@export var attack_consume_endurance: int = 20
@export var special_attack_consume_endurance: int = 40
@export var max_charge: int = 10
@export var need_charge: int = 3
@export var hit_ready_time: float = 0.1
@export var hit_damage: int = 10
@export var projectile_speed: int = 0.1

@export var current_charge: int = 0
@export var is_special_charge: bool = false


func _ready() -> void:
	read_data()
	
	hitbox.damage = hit_damage
	hitbox.ready_time = hit_ready_time as float
	hitbox_collision.disabled = true


func read_data():
	if !data_name:
		return
	
	var data = Global.weapon_data.get(data_name)
	
	attack_consume_endurance = data.attack_consume_endurance
	special_attack_consume_endurance = data.special_attack_consume_endurance
	max_charge = data.max_charge
	need_charge = data.need_charge
	hit_ready_time = data.hit_ready_time
	hit_damage = data.hit_damage
	projectile_speed = data.projectile_speed

func special_attack():
	pass

func special_consume():
	is_special_charge = true
	player.is_weapon_special_charge_attack = true
	player.is_endurance_disable = true
	player.set_current_endurance(player.current_endurance - special_attack_consume_endurance)

func charge_timer():
	if charge_attack_ready_timer.is_stopped():
		charge_attack_ready_timer.start()
		await charge_attack_ready_timer.timeout
		
		current_charge += 1
		print("current_charge: ", current_charge)
		if current_charge >= max_charge || !is_special_charge:
			return
		charge_timer()

func charge_comlete(animation: bool = true):
	player.is_endurance_disable = false
	player.is_weapon_special_charge_attack = false
	is_special_charge = false
	current_charge = 0
	
	animation_player.play("charge_complete") if animation else animation_player.play("RESET")
