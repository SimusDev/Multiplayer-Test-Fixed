extends Resource
class_name SD_ConsoleCommand

var groups: Array[String] = []
var _code: String 
var _value: String
var _arguments: Array[String] = []

var _console: SD_Console
var _settings: SD_Settings

var _help_data: Array[SD_ConsoleCommandHelp]

signal updated()
signal executed()

func deinit() -> void:
	_console.remove_command(self)

func init(console: SD_Console, settings: SD_Settings, cmd_code: String, cmd_value: Variant) -> void:
	_console = console
	_settings = settings
	_code = cmd_code
	_value = str(cmd_value)
	if cmd_value == null:
		_value = ""
		
	
	_settings.on_setting_added.connect(_on_setting_added)
	_settings.on_setting_removed.connect(_on_setting_removed)
	_settings.on_setting_changed.connect(_on_setting_changed)
	
	if !_value.is_empty():
		_settings.add_setting(get_code(), get_value())
		_value = _settings.get_setting_value(get_code(), "")
	
	updated.emit()
	update_command()

func _on_setting_added(setting: String) -> void:
	pass

func _on_setting_removed(setting: String) -> void:
	pass

func _on_setting_changed(setting: String) -> void:
	pass

func execute(args: Array[String] = []) -> void:
	_arguments = args.duplicate()
	if !args.is_empty():
		set_value(args[0])
	
	executed.emit()
	

func is_value_invalid() -> bool:
	return _value.is_empty()

func get_arguments() -> Array[String]:
	return _arguments

func set_value(value: Variant) -> void:
	_value = str(value)
	_settings.change_setting(get_code(), get_value())
	update_command()

func help_set(help_info: String, args_count: int = 0) -> SD_ConsoleCommandHelp:
	var help := SD_ConsoleCommandHelp.new(self, help_info, args_count)
	_help_data.append(help)
	return help

func help_get_data() -> Array[SD_ConsoleCommandHelp]:
	return _help_data

func get_value() -> String:
	return _value

func get_value_as_string() -> String:
	return _value

func get_value_as_int() -> int:
	if get_value() == "true":
		return 1
	elif get_value() == "false":
		return 0
	
	return int(get_value())

func get_value_as_float() -> float:
	return float(get_value())

func get_value_as_bool() -> bool:
	return bool(get_value_as_int())

func get_code() -> String:
	var fullcode: String = ""
	for group in groups:
		fullcode += group + "."
	return fullcode + _code

func get_unique_code() -> String:
	return _code

func update_command() -> void:
	updated.emit()
	_console.on_command_updated.emit(self)
