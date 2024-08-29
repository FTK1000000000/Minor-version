extends Node2D

@onready var animation_weapon = $AnimationWeapon
@onready var weapon_attack_ready_timer = $WeaponAttackReadyTimer
@onready var player = $".."
@onready var collision = $HitBox/CollisionShape2D
@onready var textruse: Sprite2D = $Sprite2D

var is_attack : bool = false

func _ready():
	animation_weapon.play("RESET")
	disable()

func _process(_delta):
	weapon_rotation_and_ordering()
	texturse_flip()


func weapon_rotation_and_ordering(mp = get_global_mouse_position(), gp = global_position):
	rotation_degrees = rad_to_deg(-atan2(mp.x - gp.x, mp.y - gp.y))
	if player.is_forward:
		z_index = 1
	else:
		z_index = 0

func texturse_flip():
	if player.weapon_flip:
		textruse.flip_h = true
		textruse.offset.x = -10
	else:
		textruse.flip_h = false
		textruse.offset.x = 10

func _on_player_weapon_attack():
	is_attack = true
	if is_attack && weapon_attack_ready_timer.time_left == 0:
		weapon_attack_ready_timer.start()
		enable()
		if player.weapon_flip:
			animation_weapon.play("attack_left")
		else:
			animation_weapon.play("attack_right")
		
		await weapon_attack_ready_timer.timeout
		
		is_attack = false
		disable()
		animation_weapon.play("RESET")

func enable():
	collision.disabled = false

func disable():
	collision.disabled = true
