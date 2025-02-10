extends Script
class_name Common


static var data_path = "res://data/common_property.json"
static var tile_size: int = 32
static var move_speed: int = 100
static var knokback_forec: int = 500
static var max_health: int = 100
static var attack_damage: int = 20
static var hurt_ready_time: float = 0.3
static var hurt_blink_time: float = 0.3


static func read_data():
	var data = FileFunction.json_as_dictionary(data_path)
	tile_size = data.tile_size
	move_speed = data.move_speed
	knokback_forec = data.knokback_forec
	max_health = data.max_health
	attack_damage = data.attack_damage
	hurt_ready_time = data.hurt_ready_time
	hurt_blink_time = data.hurt_blink_time
