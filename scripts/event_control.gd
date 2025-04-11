extends Object
class_name EventControl


const EVENT = preload("res://ui/event/event.tscn")


func spawn_event_ui() -> void:
	var event_ui = EVENT.instantiate()
	Global.temporary_ui.add_child(event_ui)
	
	event_ui.definition_event(roll_event())

func roll_event() -> Dictionary:
	var data = Global.event_data
	var event = data.get(data.keys()[Global.rng.randi() % data.size()])
	
	return event
