extends TextureProgressBar


@onready var hud: CanvasLayer = $".."
@onready var target: Player = $"../../Player"


func _ready():
	target.health_changed.connect(update)
	update()

func update():
	value = target.current_health * 100.0 / target.max_health
