extends Panel


@onready var classes: Label = $VBoxContainer/Classes
@onready var timer: Label = $VBoxContainer/Timer
@onready var property_background: TextureRect = $VBoxContainer/Panel/Background
@onready var player_bar: GridContainer = $VBoxContainer/Panel/VBoxContainer/Player
@onready var weapon_bar: GridContainer = $VBoxContainer/Panel/VBoxContainer/Weapon
@onready var health_value: Label = $VBoxContainer/Panel/VBoxContainer/Player/HealthValue
@onready var end_value: Label = $VBoxContainer/Panel/VBoxContainer/Player/EndValue
@onready var end_recover_value: Label = $VBoxContainer/Panel/VBoxContainer/Player/EndRecoverValue
@onready var end_recover_speed_value: Label = $VBoxContainer/Panel/VBoxContainer/Player/EndRecoverSpeedValue
@onready var move_speed_value: Label = $VBoxContainer/Panel/VBoxContainer/Player/MoveSpeedValue
@onready var move_speed_multiple_value: Label = $VBoxContainer/Panel/VBoxContainer/Player/MoveSpeedMultipleValue


@export var panel_shift: bool = false


func _ready() -> void:
	GlobalPlayerState.health_changed.connect(update_panel)
	GlobalPlayerState.endurance_changed.connect(update_panel)
	
	update_style()
	update_panel()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("panel_shift_right"):
		panel_shift = true
	elif Input.is_action_just_pressed("panel_shift_left"):
		panel_shift = false
	
	if panel_shift:
		weapon_bar.show()
		player_bar.hide()
	else:
		weapon_bar.hide()
		player_bar.show()


func update_style():
	if GlobalPlayerState.classes != "":
		classes.show()
		classes.text = Global.classes_data.classes_name.get(GlobalPlayerState.classes)
	else:
		classes.hide()
	
	if Global.game_start:
		timer.show()
	else:
		timer.hide()
	

func update_panel():
	var g = GlobalPlayerState
	health_value.text = (str(g.current_health) + "/" + str(g.max_health))
	end_value.text = (str(g.current_endurance) + "/" + str(g.max_endurance))
	end_recover_value.text = (str(g.endurance_recover_amount))
	end_recover_speed_value.text = (str(g.endurance_recover_speed))
	move_speed_value.text = (str(g.move_speed))
	move_speed_multiple_value.text = (str(g.current_move_speed_multiple))
	
