extends Control


@onready var classes_option_layer: Control = $Panel/ClassesOptionLayer
@onready var classes_option_layer_2: Control = $Panel/ClassesOptionLayer2
@onready var classes_option_layer_3: Control = $Panel/ClassesOptionLayer3

var classes: String = "tank"
var option_layer: Array = [classes_option_layer, classes_option_layer_2, classes_option_layer_3]


func _ready() -> void:
	SoundManager.setup_ui_sounds(self)
	
	classes_option_layer.hide()
	classes_option_layer_2.hide()
	classes_option_layer_3.hide()


func select_classes():
	GlobalPlayerState.update_classes(classes)


func _on_classes_option_slot_button_up() -> void:
	classes = "tank"
	classes_option_layer.show()
	classes_option_layer_2.hide()
	classes_option_layer_3.hide()


func _on_classes_option_slot_2_button_up() -> void:
	classes = "hunter"
	classes_option_layer.hide()
	classes_option_layer_2.show()
	classes_option_layer_3.hide()


func _on_classes_option_slot_3_button_up() -> void:
	classes = "mage"
	classes_option_layer.hide()
	classes_option_layer_2.hide()
	classes_option_layer_3.show()


func _on_back_button_up() -> void:
	hide()


func _on_next_button_up() -> void:
	select_classes()
	Global.new_game()
