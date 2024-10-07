extends TextureProgressBar


@onready var me = $"../../.."

func _ready():
	me.health_changed.connect(update)
	update()

func update():
	value = me.current_health * 100.0 / me.max_health
