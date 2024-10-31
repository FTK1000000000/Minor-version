extends Control


enum CLASSES_OPTION {
	barbarian,
	fighter,
	hunters
}


@onready var background: TextureRect = $Background
@onready var classes_name: Label = $VBoxContainer/ClassesName
@onready var max_health_value: Label = $VBoxContainer/Panel/VBoxContainer/Property/MaxHealthValue
@onready var max_endurance_value: Label = $VBoxContainer/Panel/VBoxContainer/Property/MaxEnduranceValue
@onready var weapon_used_value: Label = $VBoxContainer/Panel/VBoxContainer/Property/WeaponUsedValue
@onready var description: RichTextLabel = $VBoxContainer/Panel/VBoxContainer/Description/RichTextLabel

@export var classes_option: CLASSES_OPTION


func _ready() -> void:
	var classes
	match classes_option:
		CLASSES_OPTION.barbarian:
			classes = "barbarian"
		CLASSES_OPTION.fighter:
			classes = "fighter"
		CLASSES_OPTION.hunters:
			classes = "hunters"
	
	get_classes_data(classes)


func get_classes_data(classes):
	background.texture = load(GlobalPlayerState.classes_data.portraiture.get(classes))
	classes_name.text = str(GlobalPlayerState.classes_data.classes_name.get(classes))
	max_health_value.text = str(GlobalPlayerState.classes_data.property.get(classes).max_health)
	max_endurance_value.text = str(GlobalPlayerState.classes_data.property.get(classes).max_endurance)
	weapon_used_value.text = str(GlobalPlayerState.classes_data.property.get(classes).weapon_used)
	description.text = GlobalPlayerState.classes_data.description.get(classes)


func _on_button_down() -> void:
	var classes
	match classes_option:
		CLASSES_OPTION.barbarian:
			classes = "barbarian"
		CLASSES_OPTION.fighter:
			classes = "fighter"
		CLASSES_OPTION.hunters:
			classes = "hunters"
	
	var classes_name = GlobalPlayerState.classes_data.classes_name.get(classes)
	var weapon = GlobalPlayerState.classes_data.weapon.get(classes)
	var max_health = GlobalPlayerState.classes_data.property.get(classes).max_health
	var max_endurance = GlobalPlayerState.classes_data.property.get(classes).max_endurance
	
	GlobalPlayerState.classes_select.emit(classes_name, weapon, max_health, max_endurance)
