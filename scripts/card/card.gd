extends Collectible
class_name Card


func read():
	pass


func play():
	effect()
	print("[PlayCard] => ", str(item_resource.data_name))
	queue_free()


func effect():
	pass
