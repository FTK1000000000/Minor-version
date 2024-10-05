extends CharacterBody2D
class_name Player

signal player_dead
signal health_changed


@onready var body_texture: Node2D = $Texture/Body
@onready var antimation_tree: AnimationTree = $AnimationTree
@onready var HEAP: AnimationPlayer = $HurtEffectPlayer
@onready var hurt_effect_timer: Timer = $HurtEffectTimer
@onready var hurt_box: Hurtbox = $Hurtbox

@onready var weapon_node: Node2D = $Weapon
@onready var weapon_hitbox: Hitbox = $Weapon.weapon.hitbox
var is_weapon_attack: bool = false

@onready var state_chart: StateChart = $StateChart
@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")

@export var attack: bool = false
@export var is_dead: bool = false

var direction: Vector2 = Vector2.ZERO

@export var move_speed: float = 100
@export var current_health: int
@export var weapon_attack_damage: int = 10
var knockback_power: int = 3000
var is_hurt: bool = false

var is_forward: bool = true
var weapon_flip: bool = true


func _ready():
	if get_tree().current_scene is WORLD:
		Global.game_save()
	current_health = Global.player_current_health
	health_changed.emit()
	
	weapon_node.weapon.animation_player.play("RESET")
	if weapon_attack_damage != 0:
		weapon_hitbox.damage = weapon_attack_damage

func _process(_delta):
	move_and_slide()
	get_move_direction()
	
	update_state()
	update_animation_parametrs()
	
	handle_health()
	
	weapon_node.weapon_transform()
	weapon_node.weapon_special_attack()


func update_state():
	var is_still = velocity == Vector2.ZERO
	var switch: bool = false
	
	if Input.is_action_pressed("switch"):
		if switch:
			switch = false
		else:
			switch = true
	
	if is_still:
		state_chart.send_event("idle")
	if !is_still:
		if !is_still && !switch:
			state_chart.send_event("walk")
		else:
			state_chart.send_event("run")
	
	if Input.is_action_just_pressed("attack"):
		state_chart.send_event("weapon_attack")
	elif Input.is_action_pressed("attack_special"):
		state_chart.send_event("weapon_special_attack")
	
	if is_dead:
		state_chart.send_event("dead")
#更新状态
#受伤状态由 $HurtBox 发起

func handle_health():
	if Global.player_current_health <= 0 :
		is_dead = true
		Global.player_dead = true
		player_dead.emit()
#血量操作

func get_move_direction():
	if is_dead: return
	
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		velocity = direction * move_speed
	else:
		velocity = Vector2.ZERO
#移动

func update_animation_parametrs():
	if is_dead: return
	
	var m = get_local_mouse_position()
	if m.x < 0:
		weapon_flip = true
		body_texture.flip_h = true
	else:
		weapon_flip = false
		body_texture.flip_h = false
	
	antimation_tree["parameters/idle/blend_position"] = m
	antimation_tree["parameters/run/blend_position"] = m
	#纹理朝向和渲染索引

func knockback(enemy_velocity : Vector2):
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()


func to_dict() -> Dictionary:
	return {
		max_health = Global.player_max_health,
		current_health = Global.player_current_health
	}

func from_dict(dict: Dictionary):
	Global.player_max_health = dict.max_health
	Global.player_current_health = dict.current_health


func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
	
	print(name, " pickup: ", area.name, " -> ", area)
#拾取物品


func _on_idle_state_entered() -> void:
	#print(name, " state: idle")
	antimation_tree["parameters/conditions/is_idle"] = true
	antimation_tree["parameters/conditions/is_run"] = false


func _on_walk_stack_state_entered() -> void:
	print(name, " state: walk.walk")
	antimation_tree["parameters/conditions/is_idle"] = false
	antimation_tree["parameters/conditions/is_run"] = true
	#SoundManager.play_sfx("aa")


func _on_run_state_entered() -> void:
	print(name, " state: walk.run")
	move_speed = 150


func _on_run_state_exited() -> void:
	move_speed = 100


func _on_weapon_attack_state_entered() -> void:
	print(name, " state: weapon_attack")
	weapon_node.weapon_attack()


func _on_weapon_special_attack_state_entered() -> void:
	print(name, " state: weapon_special_attack")
	weapon_node.weapon_special_attack()


func _on_hurt_state_entered() -> void:
	print(name, " state: hurt")
	Global.player_current_health = current_health
	health_changed.emit()
	is_hurt = true
	HEAP.play("hurt_blink")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	HEAP.play("RESET")
	is_hurt = false


func _on_dead_state_entered() -> void:
	print(name, " state: dead")
	pass
