extends CanvasLayer


@onready var erro_label: Label = $ErroLabel
@onready var options_menu: CanvasLayer = $OptionsMenu
@onready var pause_layer: CanvasLayer = $Pause
@onready var tips_label: Control = $TipsLabel
@onready var player_property_panel: Panel = $PlayerPropertyPanel
@onready var player_ability_panel: Panel = $PlayerAbilityPanel

@onready var game_over_screen: CanvasLayer = $GameOverScreen

@onready var player_variable_container: VBoxContainer = $PlayerVariable
@onready var inventory: Control = $Inventory

@onready var player: Player = $"../Player"


func _ready():
	player_property_panel.hide()
	player_ability_panel.hide()
	Global.HUD = self
	Global.erro_label = erro_label
	Global.erro_label.hide()
	Global.erro_label.text = ""
	
	if Global.game_guidance:
		tips_label.show()
	else:
		tips_label.hide()
	
	player.player_dead.connect(game_over)


func _input(event):
	if event.is_action_pressed("pause"):
		if pause_layer.visible && !options_menu.visible:
			pause_layer.hide()
			player_variable_container.show()
			Global.game_keep()
		elif !pause_layer.visible && !options_menu.visible:
			pause_layer.show()
			player_variable_container.hide()
			Global.game_pause()
	
	elif event.is_action_pressed("options"):
		if options_menu.visible && !pause_layer.visible:
			options_menu.hide()
			player_variable_container.show()
			Global.game_keep()
		elif !options_menu.visible && !pause_layer.visible:
			options_menu.show()
			player_variable_container.hide()
			Global.game_pause()
	
	if event.is_action_pressed("open_bin_from_inventory"):
		if inventory.bin_is_open:
			inventory.bin_close()
		else:
			inventory.bin_open()
	
	if event.is_action_pressed("tip"):
		if tips_label.visible:
			tips_label.hide()
		else:
			tips_label.show()
	
	if event.is_action_pressed("player_property_panel"):
		if player_property_panel.visible:
			player_property_panel.hide()
		else:
			player_property_panel.show()
	
	if event.is_action_pressed("player_ability_panel"):
		if player_ability_panel.visible:
			player_ability_panel.hide()
		else:
			player_ability_panel.show()


func game_over():
	if GlobalPlayerState.player_dead && !game_over_screen.visible:
		game_over_screen.game_over()
		player_variable_container.hide()
