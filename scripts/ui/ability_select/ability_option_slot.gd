extends Button


@onready var ability_icon_node: TextureRect = $Background
@onready var ability_name_node: Label = $VBoxContainer/AbilityName
@onready var ability_description_node: RichTextLabel = $VBoxContainer/Control/AbilityDescription

@export var ability: String


func _ready() -> void:
	var g = GlobalPlayerState
	var classes = GlobalPlayerState.player_classes
	var common_ability: Array
	var ability_list: Array
	var ability_name: String
	var ability_description: String
	var ability_icon: Resource
	
	common_ability = g.common_ability
	ability_list = g.remainder_ability.duplicate()
	ability_list.append_array(common_ability)
	ability = ability_list[randi() % ability_list.size()]
	
	if ability in common_ability:
		ability_name = g.classes_data.ability.common.get(ability).name
		ability_description = g.classes_data.ability.common.get(ability).description
	else:
		ability_name = g.classes_data.ability.get(classes).get(ability).name
		ability_description = g.classes_data.ability.get(classes).get(ability).description
	ability_icon = load(g.classes_data.ability.icon.get(ability))
	
	ability_name_node.text = ability_name
	ability_description_node.text = ability_description
	ability_icon_node.texture = ability_icon


func _on_button_down() -> void:
	GlobalPlayerState.get_ability(ability)
