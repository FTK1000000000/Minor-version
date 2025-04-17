extends Object
class_name Deck

signal update


enum PILE {
	HEAD,
	DEAW,
	DISCARD
}


var draw_pile: Array[InventoryCard]
var discard_pile: Array[InventoryCard]
var head_pile: Array[InventoryCard]
var max_head_card_amount: int


func clear() -> void:
	draw_pile.clear()
	discard_pile.clear()
	head_pile.clear()

func shuffle():
	var cards = discard_pile
	draw_pile += cards
	discard_pile.clear()

func discard(card: InventoryCard, pile: PILE = 0):
	match pile:
		PILE.HEAD: head_pile.erase(card)
		PILE.DEAW: draw_pile.erase(card)
	discard_pile.push_back(card)
	update.emit()

func add_to_head_pile(item: InventoryCard):
	head_pile.push_back(item)
	update.emit()

func draw_amount(amount: int = 1):
	var target_amount = amount
	
	while target_amount > 0:
		if draw_pile.is_empty():
			shuffle()
		else:
			var card = draw_pile.pop_front()
			
			if head_pile.size() >= max_head_card_amount:
				discard(card)
			else:
				add_to_head_pile(card)
			target_amount -= 1
