extends Control


const BACKGROUND_PATH = "res://texture/ui/classes_selection/"

enum CLASSES_OPTION {
	tank,
	hunter,
	mage
}


@onready var background: TextureRect = $Background
@onready var classes_name: Label = $VBoxContainer/ClassesName
@onready var health: Label = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Health
@onready var endurance: Label = $VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Endurance
@onready var skill: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Skill
@onready var curse: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Curse
@onready var description: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Description

@export var classes_option: CLASSES_OPTION
var classes: String
var classes_data: Dictionary


func _ready() -> void:
	match classes_option:
		CLASSES_OPTION.tank:
			classes = "tank"
		CLASSES_OPTION.hunter:
			classes = "hunter"
		CLASSES_OPTION.mage:
			classes = "mage"
	
	get_classes_data(classes)


func get_classes_data(classes):
	classes_data = Global.classes_data
	classes_name.text = str(classes_data.classes_name.get(classes))
	health.text = ("Health:" + str(classes_data.property.get(classes).max_health))
	endurance.text = ("Endurance:" + str(classes_data.property.get(classes).max_endurance))
	skill.text = ("skill:" + str(classes_data.skill.get(classes)))
	curse.text = ("curse:" + str(classes_data.curse.get(classes)))
	description.text = classes_data.description.get(classes)
	
	background.texture = load(FileFunction.get_file_list(BACKGROUND_PATH).get(classes))
