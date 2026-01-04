@tool
extends SD_Translation
class_name SD_TranslationDictionary

@export var _data: Dictionary[StringName, StringName]

func _init() -> void:
	for key in _data:
		var message: StringName = _data[key]
		add_message(key, message)
