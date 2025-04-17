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
				text += str(i.get(i.keys()[n])) + " " + i.keys()[n]
			
			if (range.find(i) + 1) < range.size():
				r += text + ", "
			else:
				r += text
		return r
	
	description.text = set_text.call("give") + "\n" + set_text.call("lose")
	ation.text = ation_text


func roll_card() -> InventoryCard:
	var path = Global.card_data
	var key = path.keys()[Global.rng.randi() % path.size()]
	var card_data = path.get(key)
	
	return Global.ig.definition_item(key)

func selected():
	var property_quation = func(opation: Array) -> void:
		for item: Dictionary in opation:
			for key in item:
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
	analysis_item()

func analysis_item():
	var give_card: Array[InventoryCard]
	var give_effect: Array[Effect]
	var lose_card: Array[InventoryCard]
	var lose_effect: Array[Effect]
	
	for give: Dictionary in item.give:
		for key: String in give:
			match key:
				"card":
					match give.get(give.keys()[0]):
						"rand":
							give_card.append(roll_card())
	
	for give: Dictionary in effect.give:
		for key: String in give:
			match key:
				"card":
					match give.get(give.keys()[0]):
						"rand":
							var path = Global.effect_data
							var rng = Global.rng
							var effect: Effect = load(path.get(path.keys()[rng.randi() % path.size()])).instantiate()
							give_effect.append(effect)
	
	for lose: Dictionary in item.lose:
		var path = Global.deck.draw_pile
		for key: String in lose:
			match key:
				"card":
					match lose.get(lose.keys()[0]):
						"all":
							Global.deck.clear()
						"rand":
							path.erase(path[randi() % path.size()])
	
	for lose: Dictionary in effect.lose:
		var path = GlobalPlayerState.effects
		for key: String in lose:
			match key:
				"all":
					match lose.get(lose.keys()[0]):
						"all":
							path.clear()
						"rand":
							path.erase(path[randi() % path.size()])
				"buff":
					match lose.get(lose.keys()[0]):
						"all":
							pass
						"rand":
							pass
				"debuff":
					match lose.get(lose.keys()[0]):
						"all":
							pass
						"rand":
							pass
	
	GlobalPlayerState.get_effect()
	GlobalPlayerState.effects.append_array(give_effect)
	Global.deck.head_pile.append_array(give_card)
	Global.deck.update.emit()


func _on_ation_button_up() -> void:
	selected()
	get_parent().owner.queue_free()
