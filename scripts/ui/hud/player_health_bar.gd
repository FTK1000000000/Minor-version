extends TextureProgressBar


@onready var target: Player = $"../../../Player"


func _ready():
	target.health_changed.connect(update)
	update()


func update():
	value = target.current_health * 100.0 / Global.player_max_health
