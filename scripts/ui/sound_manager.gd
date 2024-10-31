extends Node


enum BUS {
	MASTER,
	SFX,
	BGM
}

@onready var sfx: Node = $SFX
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer


func play_sfx(name: String):
	var player = sfx.get_node(name) as AudioStreamPlayer
	
	if !player:
		return
	player.play()

func play_bgm(stream: AudioStream):
	if bgm_player.stream == stream && bgm_player.playing:
		return
	bgm_player.stream = stream
	bgm_player.play()

func setup_ui_sounds(node: Node):
	var button = node as Button
	if button:
		button.pressed.connect(play_sfx.bind("UIPress"))
		button.focus_entered.connect(play_sfx.bind("UIFocus"))
		button.mouse_entered.connect(button.grab_focus)
	
	var slider = node as Slider
	if slider:
		slider.value_changed.connect(play_sfx.bind("UIPress").unbind(1))
		slider.focus_entered.connect(play_sfx.bind("UIFocus"))
		slider.mouse_entered.connect(slider.grab_focus)
	
	for child in node.get_children():
		setup_ui_sounds(child)
#音效自动装配

func get_volume(bus_index: int):
	var db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)

func set_volume(bus_index: int, v: float):
	var db = linear_to_db(v)
	AudioServer.set_bus_volume_db(bus_index, db)
