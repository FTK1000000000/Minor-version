extends CharacterBody2D
class_name PLAYER

signal health_changed
signal weapon_attack

enum Action_State {
	IDLE,
	RUNING
}

@onready var state_chart: StateChart = $StateChart
@onready var body_texturse: Node2D = $Texturse/Body
@onready var antimation_tree : AnimationTree = $AnimationTree
@onready var hurt_effect = $HurtEffect
@onready var hurt_effect_timer = $HurtEffectTimer
@onready var hurt_box = $HurtBox
@onready var weapon: Node2D = $Weapon

@export var inventory : Inventory

@export var state : Action_State
@export var attack : bool = false
@export var dead : bool = false

var direction : Vector2 = Vector2.ZERO
var towards : Vector2 = Vector2.ZERO

var move_speed : float = 100
var max_health : int = 100
var current_health : int

@export var knockback_power : int = 300
var is_hurt : bool = false

var is_forward: bool = true
var weapon_flip: bool = true


func _ready():
	antimation_tree.active = true
	
	current_health = max_health
	health_changed.emit()
	
	hurt_effect.play("RESET")

func _process(_delta):
	move_and_slide()
	get_move_direction()
	update_animation_parametrs(Vector2.ZERO)
	weapon_attack_signal()
	collison_detect()
	handle_health()
	update_state()


func update_state():
	var is_still = velocity == Vector2.ZERO
	var switch: bool = false
	if Input.is_action_pressed("switch"):
		if switch: switch = false
		else: switch = true
	print(switch)
	if is_still: state_chart.send_event("idle")
	if !is_still:
		if !is_still && !switch: state_chart.send_event("walk")
		else: state_chart.send_event("run")
		

func get_move_direction():
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO

func update_animation_parametrs(_move_input : Vector2):
	towards = get_local_mouse_position()
	if towards.x < 0:
		weapon_flip = true
		body_texturse.flip_h = true
	else:
		weapon_flip = false
		body_texturse.flip_h = false
	if towards.y > 0:
		is_forward = true
		z_index + 1
	else:
		is_forward = false
		z_index - 1
	
	antimation_tree["parameters/idle/blend_position"] = towards
	antimation_tree["parameters/run/blend_position"] = towards
	#纹理朝向和渲染索引

func weapon_attack_signal():
	if Input.is_action_pressed("attack"):
		weapon_attack.emit()

func collison_detect():
	if !is_hurt:
		for area in hurt_box.get_overlapping_areas():
			if area.name == "HitBox":
				hurt_by_enemy(area)

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


func _on_idle_state_entered() -> void:
	#print("idle")
	antimation_tree["parameters/conditions/is_idle"] = true
	antimation_tree["parameters/conditions/is_run"] = false


func _on_walk_stack_state_entered() -> void:
	#print("walk")
	antimation_tree["parameters/conditions/is_idle"] = false
	antimation_tree["parameters/conditions/is_run"] = true


func _on_run_state_entered() -> void:
	#print("run")
	move_speed = 150
	antimation_tree["parameters/conditions/is_idle"] = false
	antimation_tree["parameters/conditions/is_run"] = true


func _on_run_state_exited() -> void:
	move_speed = 100
