extends TextureProgressBar


@onready var target: Player = $"../../../Player"


func _ready():
	target.endurance_changed.connect(update)
	update()


func update():
	value = target.current_endurance * 100.0 / Global.player_max_endurance
