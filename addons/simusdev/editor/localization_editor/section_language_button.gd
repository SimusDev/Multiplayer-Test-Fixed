@tool
class_name SD_EditorUILanguageSectionButton extends Button

@export var section:String

func _init() -> void:
	custom_minimum_size = Vector2(40.0, 30.0)

func _ready() -> void:
	text = section
