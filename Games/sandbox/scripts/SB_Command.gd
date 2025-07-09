extends RefCounted
class_name SB_ConCommand

var _source: SD_ConsoleCommand

var code: String

func _init(el_code: String, source: SD_ConsoleCommand) -> void:
	code = el_code
	_source = source

func get_source() -> SD_ConsoleCommand:
	return _source

static func get_or_create(code: String, value: Variant = "") -> SB_ConCommand:
	return SB_SModuleCommands.get_or_create(code, value)

static func get_or_create_server(code: String, value: Variant = "") -> SB_ConCommand:
	return SB_SModuleCommands.get_or_create_server(code, value)

static func get_or_create_client(code: String, value: Variant = "") -> SB_ConCommand:
	return SB_SModuleCommands.get_or_create_client(code, value)
