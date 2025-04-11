extends Control


const OPATION = preload("res://ui/event/opation.tscn")


@onready var title: Label = $Panel/CenterContainer/VBoxContainer/Title
@onready var description: Label = $Panel/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Description
@onready var graphics: TextureRect = $Panel/CenterContainer/VBoxContainer/PanelContainer/VBoxContainer/Graphics
@onready var opation_bar: HBoxContainer = $Panel/CenterContainer/VBoxContainer/OpationBar


func definition_event(data: Dictionary) -> void:
	title.text = data.title
	description.text = data.description
	for opation in data.opations:
		var opation_ui = OPATION.instantiate()
		opation_ui.ation_text = opation.ation
		opation_ui.property = opation.property
		opation_ui.item = opation.item
		opation_ui.effect = opation.effect
		
		opation_bar.add_child(opation_ui)
