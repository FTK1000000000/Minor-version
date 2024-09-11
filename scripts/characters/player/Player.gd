extends CharacterBody2D
class_name Player

signal player_dead
signal health_changed
signal weapon_attack


@onready var body_texture: Node2D = $Texture/Body
@onready var antimation_tree: AnimationTree = $AnimationTree
@onready var HEAP: AnimationPlayer = $HurtEffectPlayer
@onready var hurt_effect_timer: Timer = $HurtEffectTimer
@onready var hurt_box: Area2D = $Hurtbox
@onready var weapon: Node2D = $Weapon
@onready var state_chart: StateChart = $StateChart
@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")

@export var attack : bool = false
@export var is_dead : bool = false

var direction : Vector2 = Vector2.ZERO
var towards : Vector2 = Vector2.ZERO

var move_speed : float = 100
var max_health : int = 100
var current_health : int

@export var knockback_power : int = 3000
var is_hurt : bool = false

@export var is_forward: bool = true
var weapon_flip: bool = true


func _ready():
	Global.player = self
	
	antimation_tree.active = true
	
	current_health = max_health
	health_changed.emit()
	
	HEAP.play("RESET")

func _process(_delta):
	move_and_slide()
	get_move_direction()
	update_animation_parametrs(Vector2.ZERO)
	weapon_attack_signal()
	handle_health()
	update_state()


func update_state():
	var is_still = velocity == Vector2.ZERO
	var switch: bool = false
	
	if Input.is_action_pressed("switch"):
		if switch: switch = false
		else: switch = true
	
	if is_dead: state_chart.send_event("dead")
	if is_still: state_chart.send_event("idle")
	if !is_still:
		if !is_still && !switch: state_chart.send_event("walk")
		else: state_chart.send_event("run")
	#受伤状态由 $HurtBox 发起
#更新状态

func handle_health():
	if current_health <= 0 :
		is_dead = true
		Global.player_dead = true
		player_dead.emit()
		
#血量操作

func get_move_direction():
	if is_dead:
		return
	
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO
#移动

func update_animation_parametrs(_move_input : Vector2):
	if is_dead:
		return
	
	towards = get_local_mouse_position()
	if towards.x < 0:
		weapon_flip = true
		body_texture.flip_h = true
	else:
		weapon_flip = false
		body_texture.flip_h = false
	if towards.y > 0:
		is_forward = true
		set_z_index(10 + 1)
	else:
		is_forward = false
		set_z_index(10 - 1)
	
	antimation_tree["parameters/idle/blend_position"] = towards
	antimation_tree["parameters/run/blend_position"] = towards
	#纹理朝向和渲染索引

func knockback(enemy_velocity : Vector2):
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()

func weapon_attack_signal():
	if Input.is_action_pressed("attack"):
		weapon_attack.emit()

#func to_dict() -> Dictionary:
	#return {
		#max_health = max_health,
		#current_health = current_health
	#}
#
#func from_dict(dict: Dictionary):
	#max_health = dict.max_health
	#current_health = dict.current_health


func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
#拾取物品

func _on_dead_state_entered() -> void:
	#Global.reload_world()
	pass
	

func _on_idle_state_entered() -> void:
	#print("idle")
	antimation_tree["parameters/conditions/is_idle"] = true
	antimation_tree["parameters/conditions/is_run"] = false


func _on_walk_stack_state_entered() -> void:
	#print("walk")
	antimation_tree["parameters/conditions/is_idle"] = false
	antimation_tree["parameters/conditions/is_run"] = true
	SoundManager.play_sfx("aa")


func _on_run_state_entered() -> void:
	#print("run")
	move_speed = 150


func _on_run_state_exited() -> void:
	move_speed = 100


func _on_hurt_state_entered() -> void:
	#print("hurt")
	health_changed.emit()
	is_hurt = true
	HEAP.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	HEAP.play("RESET")
	is_hurt = false
