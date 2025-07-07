extends RefCounted
class_name EL_ConCommand

var _source: SD_ConsoleCommand

var code: String

func _init(el_code: String, source: SD_ConsoleCommand) -> void:
	code = el_code
	_source = source

func get_source() -> SD_ConsoleCommand:
	return _source
