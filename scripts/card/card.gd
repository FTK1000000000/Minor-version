extends Collectible
class_name Card


const TEST_ICON = preload("res://texture/card/test.png")


func _ready() -> void:
	read()


func read():
	item_resource = InventoryCard.new()
	var card_data = Global.card_data.get(data_name)
	var texture = FileFunction.get_file_list(Global.CARD_TEXTURE_DIRECTORY).get(data_name)
	if !icon: icon = get_child(1) 
	if !texture: icon.texture = TEST_ICON
	else: icon.texture = load(FileFunction.get_file_list(Global.CARD_TEXTURE_DIRECTORY).get(data_name))
	item_resource.icon = icon.texture
	item_resource.data_name = data_name
	item_resource.name = card_data.name
	item_resource.description = card_data.description
	item_resource.price = card_data.price
	

func play():
	effect()
	print("[PlayCard] => ", str(item_resource.data_name))
	queue_free()

func effect():
	pass