extends CanvasLayer


@onready var options_menu: CanvasLayer = $OptionsMenu
@onready var player_health_bar: TextureProgressBar = $PlayerHealthBar
@onready var inventory = $Inventory
@onready var player: Player = Global.player
@onready var pause_layer: CanvasLayer = $Pause


func _ready():
	inventory.close()


func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		if inventory.is_open:
			inventory.close()
		else:
			inventory.open()
	
	if event.is_action_pressed("pause"):
		if pause_layer.visible && !options_menu.visible:
			pause_layer.visible = false
			player_health_bar.visible = true
			Global.game_keep()
		elif !pause_layer.visible && !options_menu.visible:
			pause_layer.visible = true
			player_health_bar.visible = false
			Global.game_pause()
	
	if event.is_action_pressed("options"):
		if options_menu.visible && !pause_layer.visible:
			options_menu.visible = false
			player_health_bar.visible = true
			Global.game_keep()
		elif !options_menu.visible && !pause_layer.visible:
			options_menu.visible = true
			player_health_bar.visible = false
			Global.game_pause()
