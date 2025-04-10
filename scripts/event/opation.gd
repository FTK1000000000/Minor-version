extends PanelContainer


@onready var ation: Button = $VBoxContainer/Ation
@onready var description: Label = $VBoxContainer/Description


var ation_text: String
var property: Dictionary = {"give": [], "lose": []}
var item: Dictionary = {"give": [], "lose": []}
var effect: Dictionary = {"give": [], "lose": []}


func _ready() -> void:
	var set_text = func(v: String) -> String:
		var range: Array = property.get(v) + item.get(v) + effect.get(v)
		var r: String = v + ": " if !range.is_empty() else ""
		for i: Dictionary in range:
			var text: String
			for n: int in range(i.size()):
				text += i.keys()[n] + " " + str(i.get(i.keys()[n]))
			r += text + " "
		return r
	description.text = set_text.call("give") + "\n" + set_text.call("lose")
	ation.text = ation_text


func analysis_word():
	var give_card: Array[InventoryCard]
	var range: Array = [property, item, effect]
	for item: Dictionary in range:
		for n: int in range(item.give.size()):
			if item.give[n].get(item.give[n].keys()[n]) == Common.key.rand:
				match item.give[n].keys()[n]:
					"card": give_card.append(definition_card())
	
	Global.deck.head_pile.append_array(give_card)
	Global.deck.update.emit()

func definition_card() -> InventoryCard:
	var path = Global.card_data
	var key = path.keys()[Global.rng.randi() % path.size()]
	var card_data = path.get(key)
	var card_res: InventoryCard = InventoryCard.new()
	card_res.data_name = key
	card_res.name = card_data.name
	card_res.type = card_data.type
	card_res.description = card_data.description
	card_res.price = card_data.price
	card_res.icon = FileFunction.get_file_list(Global.CARD_TEXTURE_DIRECTORY).get(card_data.name)
	
	return card_res

func selected() -> void:
	var property_quation = func(opation: Array) -> void:
		for item: Dictionary in opation:
			var key = item.keys().front()
			var value = item.get(key)
			if opation == property.give:
				match key:
					"current_health": GlobalPlayerState.current_health += value
					"max_health": GlobalPlayerState.max_health += value
					"max_endurance": GlobalPlayerState.max_endurance += value
					"money": GlobalPlayerState.money += value
			else:
				match key:
					"current_health": GlobalPlayerState.current_health -= value
					"max_health": GlobalPlayerState.max_health -= value
					"max_endurance": GlobalPlayerState.max_endurance -= value
					"money": GlobalPlayerState.money -= value
	property_quation.call(property.give)
	property_quation.call(property.lose)
	
	
	analysis_word()


func _on_ation_button_up() -> void:
	selected()
	Global.temporary_ui.hide()
