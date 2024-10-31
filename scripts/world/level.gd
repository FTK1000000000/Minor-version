extends World


func _ready() -> void:
	super()
	Global.game_save()
	Global.game_start = true
	GlobalPlayerState.update_ability()
