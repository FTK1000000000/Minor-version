extends Interactable
class_name BossSummon


@onready var boss_room: BossRoom = $".."

@export var boss: PackedScene


func interaction():
	interacted.emit()
	print("interaction to ", name)
	
	if boss:
		boss_room.spawn_boss(boss)
	else:
		print("[boss spawn] => boss is null")
