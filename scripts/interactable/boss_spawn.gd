extends Interactable
class_name BossSummon


@onready var boss_room: BossRoom = $".."

@export_file() var boss


func interaction():
	interacted.emit()
	print("interaction to ", name)
	
	if boss:
		boss_room.spawn_boss(boss)
	else:
		print("[boss spawn] => boss is null")
