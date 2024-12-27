extends Card


func effect():
	GlobalPlayerState.money += 7
	GlobalPlayerState.money_changed.emit()
