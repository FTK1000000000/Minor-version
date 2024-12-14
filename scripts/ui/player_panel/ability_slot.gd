extends Panel


@onready var player_ability_panel: Panel = $"../.."
@onready var background_color: ColorRect = $Background
@onready var ability_icon_node: TextureRect = $Icon
@onready var ability_name_node: Label = $Icon/Name
#@onready var ability_description_node: RichTextLabel = $VBoxContainer/Control/AbilityDescription

@export var ability: String


func _ready() -> void:
	var classes = GlobalPlayerState.player_classes
	var common_ability = GlobalPlayerState.common_ability
	var ability_list = player_ability_panel.ability_list
	var ability_name: String
	var ability_description: String
	var ability_icon: Resource
	
	if ability_list.size() != 0:
		ability = ability_list.pop_front()
		
		if ability in common_ability:
			ability_name = Global.classes_data.ability.common.get(ability).name
			#ability_description = g.classes_data.ability.common.get(ability).description
		else:
			ability_name = Global.classes_data.ability.get(classes).get(ability).name
			#ability_description = g.classes_data.ability.get(classes).get(ability).description
		ability_icon = load(Global.classes_data.ability.icon.get(ability))
	
	ability_name_node.text = ability_name
	ability_icon_node.texture = ability_icon
