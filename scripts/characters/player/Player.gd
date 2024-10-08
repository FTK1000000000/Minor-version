extends CharacterBody2D
class_name Player

signal health_changed
signal endurance_changed
signal player_dead


@onready var body_texture: Node2D = $Texture/Body
@onready var antimation_tree: AnimationTree = $AnimationTree
@onready var HEAP: AnimationPlayer = $HurtEffectPlayer
@onready var endurance_recover_timer: Timer = $EnduranceRecoverTimer
@onready var end_recover_ready_timer: Timer = $EndRecoverReadyTimer
@onready var hurt_effect_timer: Timer = $HurtEffectTimer
@onready var hurt_box: Hurtbox = $Hurtbox

@onready var weapon_node: Node2D = $Weapon

@onready var state_chart: StateChart = $StateChart
@onready var inventory: Inventory = preload("res://inventory/player_inventory.tres")

@export var direction: Vector2 = Vector2.ZERO

@export var walk_move_speed: int = 100
@export var run_move_speed: int = 200
@export var current_move_speed: int
@export var current_health: int
@export var current_endurance: int
@export var endurance_recover_amount: int = 10
@export var endurance_recover_ready: int = 1
@export var endurance_recover_speed: float = 0.2
@export var endurance_recover_ready_speed: float = 0.5
@export var knockback_power: int = 3000

@export var is_idle: bool = true
@export var is_walk: bool = false
@export var is_resist: bool = false
@export var is_weapon_attack: bool = false
@export var weapon_flip: bool = false
@export var is_endurance_disable: bool = false
@export var is_hurt: bool = false

@export var is_flip: bool = true
@export var is_dead: bool = false


func _ready():
	if get_tree().current_scene is WORLD:
		Global.game_save()
	current_health = Global.player_current_health
	current_endurance = Global.player_current_endurance
	
	current_move_speed = walk_move_speed
	endurance_recover_timer.wait_time = endurance_recover_speed
	end_recover_ready_timer.wait_time = endurance_recover_ready_speed
	
	health_changed.emit()
	endurance_changed.emit()

func _process(_delta):
	move_and_slide()
	get_move_direction()
	
	update_state()
	update_animation_parametrs()
	
	handle_health()
	headle_endurance()
	
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
	
	if is_still && is_walk:
		is_idle = true
		is_walk = false
		state_chart.send_event("idle")
	
	if !is_still:
		is_walk = true
		is_idle = false
		if !is_still && !switch:
			state_chart.send_event("walk")
		elif !is_still && switch && current_endurance > 0:
			state_chart.send_event("run")
	
	if Input.is_action_just_pressed("attack"):
		state_chart.send_event("weapon_attack")
	
	if is_dead:
		state_chart.send_event("dead")
#更新状态
#受伤状态由 $HurtBox 发起

func handle_health():
	if Global.player_current_health <= 0:
		is_dead = true
		Global.player_dead = true
		player_dead.emit()
#处理血量

func headle_endurance():
	if velocity == Vector2.ZERO && !is_weapon_attack:
		is_endurance_disable = false
	
	if is_endurance_disable:
		end_recover_ready_timer.start()
	
	if current_endurance < 0:
		current_endurance = 0
	elif current_endurance > Global.player_max_endurance:
		current_endurance = Global.player_max_endurance
		is_endurance_disable = true
	else:
		endurance_recover()
#处理耐力

func endurance_recover():
	if (
		end_recover_ready_timer.is_stopped() &&
		endurance_recover_timer.is_stopped()
		):
			endurance_recover_timer.start()
			await endurance_recover_timer.timeout
			
			current_endurance += endurance_recover_amount
			endurance_changed.emit()
			print(current_endurance)
			endurance_recover()

func get_move_direction():
	if is_dead: return
	
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	if direction:
		velocity = direction * current_move_speed
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
	
	if m.y < 0: is_flip = true
	else: is_flip = false
	
	antimation_tree["parameters/idle/blend_position"] = m
	antimation_tree["parameters/run/blend_position"] = m
	#纹理朝向和渲染索引

func knockback(enemy_velocity : Vector2):
	var knockback_direction = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_direction
	move_and_slide()


func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
	
	print(name, " pickup: ", area.name, " -> ", area)
#拾取物品


func _on_idle_state_entered() -> void:
	print(name, " state: idle")
	antimation_tree["parameters/conditions/is_idle"] = true
	antimation_tree["parameters/conditions/is_run"] = false


func _on_walk_stack_state_entered() -> void:
	print(name, " state: walk.walk")
	antimation_tree["parameters/conditions/is_idle"] = false
	antimation_tree["parameters/conditions/is_run"] = true
	#SoundManager.play_sfx("aa")


func _on_run_state_entered() -> void:
	print(name, " state: walk.run")
	current_move_speed = run_move_speed
	
	current_endurance -= 1
	endurance_changed.emit()
	is_endurance_disable = true
	
	if current_endurance <= 0:
		state_chart.send_event("walk")


func _on_run_state_exited() -> void:
	current_move_speed = walk_move_speed


func _on_weapon_attack_state_entered() -> void:
	print(name, " state: weapon_attack")
	weapon_node.weapon_attack()


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
