extends TextureProgressBar


@onready var player: Player = get_node("../../Player")

func _ready():
	player.health_changed.connect(update)
	update()

func update():
	value = player.current_health * 100.0 / player.max_health
