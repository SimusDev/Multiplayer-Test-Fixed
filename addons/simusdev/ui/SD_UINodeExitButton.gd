extends Node
class_name SD_UINodeExitButton

@export var button: Button

func _ready() -> void:
	if get_parent() is Button:
		button = get_parent()
	
	if !button:
		return
	
	if SD_Platforms.is_web():
		button.hide()
		return
	
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	SimusDev.quit()
