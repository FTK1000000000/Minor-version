extends exit


func interaction():
	interacted.emit()
	print("interaction to ", name)
	
	if Global.storey_level <= 3 - 1:
		Global.storey_level += 1
		Global.temporary_ui.add_child(Global.ABILITY_SELECT.instantiate())
	else:
		Global.complete_game()
