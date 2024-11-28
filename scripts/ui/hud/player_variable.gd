extends VBoxContainer


@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health_label: Label = $HealthBar/Label
@onready var eased_health_bar: TextureProgressBar = $HealthBar/EasedHealthBar
@onready var eased_health_label: Label = $HealthBar/EasedHealthBar/Label
@onready var endurance_bar: TextureProgressBar = $EnduranceBar
@onready var endurance_label: Label = $EnduranceBar/Label
@onready var eased_endurance_bar: TextureProgressBar = $EnduranceBar/EasedEnduranceBar
@onready var eased_endurance_label: Label = $EnduranceBar/Label
@onready var money_label: Label = $VBoxContainer/Money/Label


@onready var target: Player = $"../../Player"


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
	var hv = GlobalPlayerState.player_current_health * 100.0 / GlobalPlayerState.player_max_health
	var ev = GlobalPlayerState.player_current_endurance * 100.0 / GlobalPlayerState.player_max_endurance
	health_bar.value = hv
	endurance_bar.value = ev
	health_label.text = str(GlobalPlayerState.player_current_health)
	endurance_label.text = str(GlobalPlayerState.player_current_endurance)
	
	create_tween().tween_property(eased_health_bar, "value", hv, 0.4)
	create_tween().tween_property(eased_endurance_bar, "value", ev, 0.4)

func update_money():
	money_label.text = str(GlobalPlayerState.money)
