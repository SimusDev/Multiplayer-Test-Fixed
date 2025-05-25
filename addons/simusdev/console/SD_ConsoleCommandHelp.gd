extends SD_Object
class_name SD_ConsoleCommandHelp

var _cmd: SD_ConsoleCommand
var _info: String
var _args_count: int

func _init(command: SD_ConsoleCommand, info: String, args_count: int = 0) -> void:
	_cmd = command
	_info = info
	_args_count = args_count

func get_command() -> SD_ConsoleCommand:
	return _cmd

func get_info() -> String:
	return _info

func get_args_count() -> int:
	return _args_count

func get_as_string() -> String:
	return _info
