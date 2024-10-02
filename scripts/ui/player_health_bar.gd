extends TextureProgressBar


@onready var hud: CanvasLayer = $".."
@onready var target: Player = $"../../Player"


func _ready():
	target.health_changed.connect(update)
	update()

func update():
	value = Global.player_current_health * 100.0 / Global.player_max_health
