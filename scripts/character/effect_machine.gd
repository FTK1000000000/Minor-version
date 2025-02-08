extends Node
class_name EffectMachine


@export var effects: Array = []


func update_effects():
	effects.clear()
	for effect in get_children():
		var data_name = effect.data_name
		var time_left = effect.life_cycle_timer.time_left
		effects.push_back({
			"data_name": data_name,
			"time_left": time_left
		})

func add_effect(effect_name: String, time: float = 5):
	for effect in effects:
		if effect.data_name == effect_name:
			remove_effect(effect_name)
	
	var effect: Effect
	effect = load(FileFunction.get_file_list(Global.EFFECT_DIRECTORY).get(effect_name)).instantiate()
	add_child(effect)
	effect.life_cycle_timer.wait_time = time
	
	update_effects()

func remove_effect(effect_name: String):
	for effect in get_children():
		if effect.data_name == effect_name:
			effect.queue_free()
			return
	
	update_effects()

func clear_effect():
	for effect in get_children():
		effect.queue_free()
	
	update_effects()
