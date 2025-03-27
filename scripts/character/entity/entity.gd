extends CharacterBody2D
class_name Entity

signal health_changed

signal deading
signal hurting
signal attacking


@onready var state_chart: StateChart = $StateChart
@onready var effect_machine: EffectMachine = $EffectMachine
@onready var body_texture: Sprite2D = $Texture/Body
@onready var hurt_effect_timer: Timer = $HurtEffectTimer
@onready var state_player: AnimationPlayer = $StatePlayer
@onready var hurt_effect_player: AnimationPlayer = $HurtEffectPlayer

@export var hurtbox: Hurtbox

@export var max_health: int = 20
@export var current_health: int = 20
@export var hurt_ready_time: float = Common.hurt_ready_time

var is_dead: bool = false
var is_hurt: bool = false
var is_idle: bool = false


func _ready() -> void:
	deading.connect(dead_handle)
	hurting.connect(hurt_handle)


func dead_handle():
	state_chart.send_event("dead")

func hurt_handle():
	state_chart.send_event("hurt")

func set_current_health(value: int):
	current_health = value
	health_changed.emit()

func get_current_state() -> String:
	return state_chart._state._active_state.name


func _on_idle_state_entered() -> void:
	is_idle = true


func _on_idle_state_exited() -> void:
	is_idle = false


func _on_hurt_state_entered() -> void:
	is_hurt = true
	hurt_effect_player.play("hurt_blinka")
	hurt_effect_timer.start()
	await hurt_effect_timer.timeout
	
	hurt_effect_player.play("RESET")


func _on_hurt_state_exited() -> void:
	is_hurt = false


func _on_dead_state_entered() -> void:
	if !is_dead:
		is_dead = true


func _on_dead_state_exited() -> void:
	is_dead = false
