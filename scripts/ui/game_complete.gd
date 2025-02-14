extends Control


@onready var start_on_value: Label = $VBoxContainer/GridContainer/StartOnValue
@onready var complete_on_value: Label = $VBoxContainer/GridContainer/CompleteOnValue
@onready var time_value: Label = $VBoxContainer/GridContainer/TimeValue
@onready var kill_value: Label = $VBoxContainer/GridContainer/KillValue


func _ready() -> void:
	start_on_value.text = unix_time_as_string(Global.game_started_on)
	
	complete_on_value.text = unix_time_as_string(Global.game_completed_on)
	
	var duration = Global.game_completed_on - Global.game_started_on
	var minuets = duration / 60
	var seconds = duration % 60
	time_value.text = "%d:%d" % [minuets, seconds]
	
	kill_value.text = str(GlobalPlayerState.player_kill)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		Global.back_to_title()


func unix_time_as_string(unix_time: int) -> String:
	var dic = Time.get_datetime_dict_from_unix_time(unix_time)
	return "%d.%d.%d.%d.%d.%d" % [dic.year, dic.month, dic.day, dic.hour, dic.minute, dic.second]
