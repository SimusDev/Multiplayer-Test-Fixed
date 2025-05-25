@icon("res://addons/simusdev/icons/String.svg")
extends Node
class_name SD_NodeLocalization

@onready var console: SD_TrunkConsole = SimusDev.console
@onready var localization: SD_TrunkLocalization = SimusDev.localization

func get_current_language() -> String:
	return localization.get_current_language()

func set_text_to_key(key: String, text: String, language: String = get_current_language()) -> void:
	localization.set_text_to_key(key, text, language)

func get_text_from_key(key: String, language: String = get_current_language()) -> String:
	return localization.get_text_from_key(key, language)
