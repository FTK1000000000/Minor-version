extends Panel


@onready var player_ability_panel: Panel = $"../.."
@onready var background_color: ColorRect = $Background
@onready var ability_icon_node: TextureRect = $Icon
@onready var ability_name_node: Label = $Icon/Name
#@onready var ability_description_node: RichTextLabel = $VBoxContainer/Control/AbilityDescription

@export var ability: String


func _ready() -> void:
	var classes = GlobalPlayerState.classes
	var common_ability = GlobalPlayerState.common_ability
	var ability_list = player_ability_panel.ability_list
	var ability_name: String
	var ability_description: String
	var ability_icon: Resource
	
	if ability_list.size() != 0:
		ability = ability_list.pop_front()
		
		ability_name = Global.ability_data.list.get(ability).name
		#ability_description = g.classes_data.ability.common.get(ability).description
		ability_icon = load(FileFunction.get_file_list(Global.ABILITY_TEXTURE_DIRECTORY).get(ability))
	
	ability_name_node.text = ability_name
	ability_icon_node.texture = ability_icon
