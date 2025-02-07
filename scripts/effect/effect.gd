extends Node
class_name Effect


@onready var life_cycle_timer: Timer = $LifeCycleTimer
@onready var trigger_timer: Timer = $TriggerTimer
@onready var effect_machine: EffectMachine = $".."

@export var data_name: String 


#func _ready() -> void:
	#timer.start()


func effect():
	print("effect: " + data_name + " => ", owner.name)


func _on_life_cycle_timer_timeout() -> void:
	effect_machine.remove_effect(data_name)


func _on_trigger_timer_timeout() -> void:
	effect()
