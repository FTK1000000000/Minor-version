extends Node


enum Bus {
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
		button.mouse_entered.connect(play_sfx.bind("UIFocus"))
	
	for child in node.get_children():
		setup_ui_sounds(child)

func get_volume(bus_index: int):
	var db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(db)

func set_volume(bus_index: int, v: float):
	var db = linear_to_db(v)
	AudioServer.set_bus_volume_db(bus_index, db)
