extends World


@onready var rooms_generator: Node2D = $RoomsGenerator
@onready var background_tile: TileMapLayer = $BackgroundTile

@export var cards: Array = [InventoryItem]


func _ready() -> void:
	super()
	Global.game_save()
	Global.is_game_start = true
	#GlobalPlayerState.update_ability()
	Global.HUD.show()
	Global.HUD.tips_label.hide()
	rooms_generator.run()
	
	var t: TileMapLayer = background_tile
	#for x in range(-5000, 5000):
		#for y in range(-5000, 5000):
			#t.set_cell(t.local_to_map(Vector2(x, y)), 0, Vector2i(0, 0))
