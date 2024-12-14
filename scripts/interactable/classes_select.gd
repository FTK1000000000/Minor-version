extends Interactable


func interaction():
	if GlobalPlayerState.player_classes == "":
		Global.temporary_ui.add_child(Global.CLASSES_SELECT_PANEL.instantiate())
		interacted.emit()
		print("[interaction] => ", name)
	else:
		print("[interaction] not do select")
