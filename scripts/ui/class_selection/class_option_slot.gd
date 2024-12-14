extends Control


enum CLASSES_OPTION {
	tank,
	hunter,
	mage
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
		CLASSES_OPTION.tank:
			classes = "tank"
		CLASSES_OPTION.hunter:
			classes = "hunter"
		CLASSES_OPTION.mage:
			classes = "mage"
	
	get_classes_data(classes)


func get_classes_data(classes):
	background.texture = load(Global.classes_data.portraiture.get(classes))
	classes_name.text = str(Global.classes_data.classes_name.get(classes))
	max_health_value.text = str(Global.classes_data.property.get(classes).max_health)
	max_endurance_value.text = str(Global.classes_data.property.get(classes).max_endurance)
	weapon_used_value.text = str(Global.classes_data.property.get(classes).weapon_used)
	description.text = Global.classes_data.description.get(classes)


func _on_button_down() -> void:
	var classes
	match classes_option:
		CLASSES_OPTION.tank:
			classes = "tank"
		CLASSES_OPTION.hunter:
			classes = "hunter"
		CLASSES_OPTION.mage:
			classes = "mage"
	
	var classes_name = Global.classes_data.classes_name.get(classes)
	var weapon_data_name = (Global.classes_data.weapon.get(classes))
	var max_health = Global.classes_data.property.get(classes).max_health
	var max_endurance = Global.classes_data.property.get(classes).max_endurance
	
	GlobalPlayerState.update_classes(classes_name, weapon_data_name, max_health, max_endurance)
