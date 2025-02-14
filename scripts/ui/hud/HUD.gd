extends CanvasLayer


@onready var vignette: CanvasLayer = $Vignette
@onready var options_menu: CanvasLayer = $OptionsMenu
@onready var pause_layer: CanvasLayer = $Pause
@onready var player_variable_container: CanvasLayer = $PlayerVariable
@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var card_bar: CanvasLayer = $CardBar
@onready var tips_label: Control = $TipsLabel
@onready var player_property_panel: Panel = $PlayerPropertyPanel
@onready var player_ability_panel: Panel = $PlayerAbilityPanel
@onready var erro_label: Label = $ErroLabel

@onready var player: Player = $"../Player"

@export var show_layer: Array[CanvasLayer]


func _ready():
	player_property_panel.hide()
	player_ability_panel.hide()
	Global.HUD = self
	Global.erro_label.hide()
	Global.erro_label.text = ""
	
	if Global.is_game_guidance:
		tips_label.show()
	else:
		tips_label.hide()


func _input(event):
	if event.is_action_pressed("pause"):
		if pause_layer.visible:
			Global.game_keep()
		else:
			Global.game_pause()
		on_off_layer(pause_layer)
	
	elif event.is_action_pressed("options"):
		if options_menu.visible:
			Global.game_keep()
		else:
			Global.game_pause()
		on_off_layer(options_menu)
	
	elif event.is_action_pressed("tip"):
		on_off_layer(tips_label)
	
	elif event.is_action_pressed("player_property_panel"):
		if !(options_menu.visible || pause_layer.visible):
			on_off_layer(player_property_panel)
	
	elif event.is_action_pressed("player_ability_panel"):
		if !(options_menu.visible || pause_layer.visible):
			on_off_layer(player_ability_panel)


func on_off_layer(layer: Node):
	if layer.visible:
		for i in show_layer:
			i.show()
		
		layer.hide()
	else:
		for i in get_children():
			i.hide()
		
		vignette.show()
		layer.show()

func game_over_animation():
	if !game_over_screen.visible:
		game_over_screen.game_over()
