extends Control


@export var item_list: Array[InventoryItem]


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	
	close()


func open():
	Global.game_pause()
	show()

func close():
	Global.game_keep()
	hide()


func _on_back_button_up() -> void:
	close()
