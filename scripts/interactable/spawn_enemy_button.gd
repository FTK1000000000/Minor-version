extends Interactable


const ENEMY_1 = preload("res://character/entity/enemy/goblin.tscn")


func interaction():
	$Marker2D.add_child(ENEMY_1.instantiate())
	interacted.emit()
	print("[interaction] => ", name)
