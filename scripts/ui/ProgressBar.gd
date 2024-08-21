extends TextureProgressBar


@export var player : PLAYER

func _ready():
	player.health_changed.connect(update)
	update()

func update():
	value = player.current_health * 100.0 / player.max_health
