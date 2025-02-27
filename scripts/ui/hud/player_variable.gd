extends CanvasLayer


@onready var health_bar: TextureProgressBar = $VBoxContainer2/HealthBar
@onready var health_label: Label = $VBoxContainer2/HealthBar/Label
@onready var eased_health_bar: TextureProgressBar = $VBoxContainer2/HealthBar/EasedHealthBar
@onready var eased_health_label: Label = $VBoxContainer2/HealthBar/EasedHealthBar/Label
@onready var endurance_bar: TextureProgressBar = $VBoxContainer2/EnduranceBar
@onready var endurance_label: Label = $VBoxContainer2/EnduranceBar/Label
@onready var eased_endurance_bar: TextureProgressBar = $VBoxContainer2/EnduranceBar/EasedEnduranceBar
@onready var eased_endurance_label: Label = $VBoxContainer2/EnduranceBar/Label
@onready var money_label: Label = $VBoxContainer2/VBoxContainer/Money/Label

@onready var target: Player = $"../../Player"

var old_health: int
var old_endurance: int


func _ready() -> void:
	GlobalPlayerState.update_variable.connect(update)
	GlobalPlayerState.health_changed.connect(update_variable_bar)
	GlobalPlayerState.endurance_changed.connect(update_variable_bar)
	GlobalPlayerState.money_changed.connect(update_money)
	update()


func update():
	update_variable_bar()
	update_money()

func update_variable_bar():
	var ch = GlobalPlayerState.current_health
	var ce = GlobalPlayerState.current_endurance
	var hv = ch * 100.0 / GlobalPlayerState.max_health
	var ev = ce * 100.0 / GlobalPlayerState.max_endurance
	
	if old_health > ch:
		health_label.text = str(ch)
		health_bar.value = hv
		create_tween().tween_property(eased_health_bar, "value", hv, 0.4)
	else:
		health_label.text = str(ch)
		create_tween().tween_property(health_bar, "value", hv, 0.4)
		eased_health_bar.value = hv
	
	if old_endurance > ce:
		endurance_label.text = str(ce)
		endurance_bar.value = ev
		create_tween().tween_property(eased_endurance_bar, "value", ev, 0.4)
	else:
		endurance_label.text = str(ce)
		create_tween().tween_property(endurance_bar, "value", ev, 0.4)
		eased_endurance_bar.value = ev
	
	old_health = ch
	old_endurance = ce

func update_money():
	money_label.text = str(GlobalPlayerState.money)
