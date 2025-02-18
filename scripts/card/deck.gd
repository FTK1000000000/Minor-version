extends Object
class_name Deck


var draw_pile: Array[Card]
var discard_pile: Array[Card]
var head_pile: Inventory = load("res://card/head_card_inventory.tres")
var max_head_card_amount: int = GlobalPlayerState.player_max_head_card_amount


func _init() -> void:
	head_pile.slots.clear()
	
	var slot: InventorySlot
	while head_pile.slots.size() < max_head_card_amount:
		head_pile.slots.append(slot)


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
