extends CharacterBody2D
class_name PLAYER

signal health_changed
signal weapon_attack

enum Action_State {
	IDLE,
	RUNING
}

@onready var antimation_tree : AnimationTree = $AnimationTree
@onready var hurt_effect = $HurtEffect
@onready var hurt_effect_timer = $HurtEffectTimer
@onready var hurt_box = $HurtBox

@export var inventory : Inventory

@export var state : Action_State
@export var attack : bool = false
var dead : bool = false

var direction : Vector2 = Vector2.ZERO
var towards : Vector2 = Vector2.ZERO

@export var move_speed : float = 100
@export var max_health : int = 100
var current_health : int

@export var knockback_power : int = 300
var is_hurt : bool = false

var is_forward : bool = true

func _ready():
	antimation_tree.active = true
	
	current_health = max_health
	
	hurt_effect.play("RESET")

func _process(_delta):
	move_and_slide()
	set_ordering()
	move_direction()
	update_actio_state(_delta)
	update_animation_parametrs(Vector2.ZERO)
	weapon_attack_signal()
	handle_health()
	towards = get_local_mouse_position()
	
	if !is_hurt:
		for area in hurt_box.get_overlapping_areas():
			if area.name == "HitBox":
				hurt_by_enemy(area)


func set_ordering():
	if towards.y > 0:
		is_forward = true
		z_index = 100+1
	else:
		is_forward = false
		z_index = 100-1


func move_direction():
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO


func update_actio_state(_delta):
	var is_still = velocity == Vector2.ZERO
	
	if is_still:
		state = Action_State.IDLE
	if !is_still:
		state = Action_State.RUNING
	
	if Input.is_action_pressed("run"):
		move_speed = 150
	else:
		move_speed = 100
#动作判定


func update_animation_parametrs(_move_input : Vector2):
	
	antimation_tree["parameters/idle/blend_position"] = towards
	antimation_tree["parameters/run/blend_position"] = towards
	
	if state == 0:
		antimation_tree["parameters/conditions/is_idle"] = true
		antimation_tree["parameters/conditions/is_run"] = false
		
	if state == 1:
		antimation_tree["parameters/conditions/is_idle"] = false
		antimation_tree["parameters/conditions/is_run"] = true
		
#动画绑定


func weapon_attack_signal():
	if Input.is_action_pressed("attack"):
		weapon_attack.emit()


func hurt_by_enemy(area):
	current_health -= 10
	health_changed.emit()
	is_hurt = true
	knockback(area.get_parent().velocity)
	hurt_effect.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	hurt_effect.play("RESET")
	is_hurt = false


func handle_health():
	if current_health <= 0 :
		dead = true
		print(current_health)
		print("out is")
		print(dead)
		print("for")
		print(name)
		current_health = 100


func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)


func knockback(enemy_velocity : Vector2):
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()


@warning_ignore("unused_parameter")
func _on_hurt_box_area_exited(area):pass
