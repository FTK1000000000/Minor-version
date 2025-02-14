extends Enemy
class_name Boss


func _ready() -> void:
	super()
	
	Global.boss = self

func read_data():
	if !data_name:
		return
	
	var data = Global.boss_data.get(data_name)
	
	move_speed = data.move_speed
	max_health = data.max_health
	collision_damage = data.attack_damage
	attack_ready_time = data.attack_ready_time
