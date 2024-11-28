extends Card


func effect():
	GlobalPlayerState.money += 750
	GlobalPlayerState.money_changed.emit()
