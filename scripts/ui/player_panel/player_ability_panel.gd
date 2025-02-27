extends Panel


const ABILITY_SLOT = preload("res://ui/player_panel/ability_slot.tscn")


@onready var grid_container: GridContainer = $GridContainer

@export var ability_list: Array
@export var ability_number: int


func _ready() -> void:
	ability_list = GlobalPlayerState.current_ability.duplicate()
	ability_number = ability_list.size()
	
	generate()

func generate():
	if ability_number != 0:
		grid_container.add_child(ABILITY_SLOT.instantiate())
		ability_number -= 1
		generate()
