extends Object
class_name Deck

signal update


var draw_pile: Array[InventoryCard]
var discard_pile: Array[InventoryCard]
var head_pile: Array[InventoryCard]
var max_head_card_amount: int


func _init() -> void:
	head_pile.clear()


func shuffle():
	var cards = discard_pile
	draw_pile += cards
	discard_pile.clear()

func discard(card):
	if card in draw_pile: draw_pile.erase(card)
	elif card in head_pile: head_pile.erase(card)
	discard_pile.push_front(card)

func draw_to_amount(amount: int = 1):
	var target_amount = head_pile.size() + amount
	
	while head_pile.size() < target_amount:
		if draw_pile.is_empty():
			shuffle()
		else:
			var card = draw_pile.front()
			
			if head_pile.size() >= max_head_card_amount:
				discard(card)
			else:
				head_pile.push_front(card)

func add_to_head_pile(item):
	head_pile.push_front(item)
	update.emit()
