extends Node
class_name ItemGenerator


const TEST_ICON = preload("res://texture/card/test.png")


func definition_item(data_name) -> InventoryCard:
	var item_resource: InventoryCard
	var icon: Texture2D
	var card_data: Dictionary = Global.card_data.get(data_name)
	
	if data_name in FileFunction.get_file_list(Global.CARD_TEXTURE_DIRECTORY):
		icon = load(FileFunction.get_file_list(Global.CARD_TEXTURE_DIRECTORY).get(data_name))
	else:
		icon = TEST_ICON
	
	item_resource = InventoryCard.new()
	item_resource.data_name = data_name
	item_resource.name = card_data.name
	item_resource.type = card_data.type
	item_resource.description = card_data.description
	item_resource.price = card_data.price
	item_resource.icon = icon
	
	return item_resource
