extends Button


@onready var ability_icon_node: TextureRect = $Background
@onready var ability_name_node: Label = $VBoxContainer/AbilityName
@onready var ability_description_node: RichTextLabel = $VBoxContainer/Control/AbilityDescription

@export var ability: String


func _ready() -> void:
	var classes = GlobalPlayerState.player_classes
	var common_ability: Array
	var ability_list: Array
	var ability_name: String
	var ability_description: String
	var ability_icon: Resource
	
	common_ability = GlobalPlayerState.common_ability
	ability_list = GlobalPlayerState.remainder_ability.duplicate()
	ability_list.append_array(common_ability)
	ability = ability_list[randi() % ability_list.size()]
	ability_name = Global.ability_data.list.get(ability).name
	ability_description = Global.ability_data.list.get(ability).description
	ability_icon = load(FileFunction.get_file_list(Global.ABILITY_TEXTURE_DIRECTORY).get(ability))
	
	ability_name_node.text = ability_name
	ability_description_node.text = ability_description
	ability_icon_node.texture = ability_icon


func _on_button_down() -> void:
	GlobalPlayerState.get_ability(ability)
