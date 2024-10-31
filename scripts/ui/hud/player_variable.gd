extends VBoxContainer


@onready var player_health_bar: TextureProgressBar = $PlayerHealthBar
@onready var health_label: Label = $PlayerHealthBar/Label
@onready var player_endurance_bar: TextureProgressBar = $PlayerEnduranceBar
@onready var endurance_label: Label = $PlayerEnduranceBar/Label

@onready var target: Player = $"../../Player"


func _ready() -> void:
	if target:
		target.health_changed.connect(update_variable_bar)
		update_variable_bar()
		target.endurance_changed.connect(update_variable_bar)
		update_variable_bar()


func update_variable_bar():
	player_health_bar.value = target.current_health * 100.0 / GlobalPlayerState.player_max_health
	health_label.text = str(target.current_health)
	player_endurance_bar.value = target.current_endurance * 100.0 / GlobalPlayerState.player_max_endurance
	endurance_label.text = str(target.current_endurance)
