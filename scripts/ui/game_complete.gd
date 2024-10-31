extends Control


@onready var time_value: Label = $VBoxContainer/GridContainer/TimeValue
@onready var kill_value: Label = $VBoxContainer/GridContainer/KillValue


func _ready() -> void:
	var duration = Global.completed_at - Global.started_at
	var minuets = duration / 60
	var seconds = duration % 60
	time_value.text = "%d:%02" % [minuets, seconds]
	kill_value.text = str(GlobalPlayerState.player_kill)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		Global.back_to_title()
