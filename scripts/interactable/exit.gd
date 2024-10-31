extends Interactable
class_name exit


@export_file() var path


func interaction():
	interacted.emit()
	print("interaction to ", name)
	
	if path:
		Global.load_world(path)
	else:
		Global.complete_game()
