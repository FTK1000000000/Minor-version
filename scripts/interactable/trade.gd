extends Interactable


func interaction():
	super()
	
	var parent: Trader = get_parent()
	if parent.trade_panel:
		parent.trade_panel.open()
