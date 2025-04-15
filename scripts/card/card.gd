extends Collectible
class_name Card


func _ready() -> void:
	read()


func read():
	item_resource = Global.ig.definition_item(data_name)
	icon.texture = item_resource.icon
	
	#if !icon: icon = get_child(1)

func play():
	effect()
	print("[PlayCard] => ", str(item_resource.data_name))
	queue_free()

func effect():
	pass

func ability():
	pass
