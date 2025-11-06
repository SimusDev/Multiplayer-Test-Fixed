extends Resource
class_name SD_ConsoleCommand

var groups: Array[String] = []
var _code: String 
var _value: String
var _arguments: Array[String] = []

var _console: SD_Console
var _settings: SD_Settings

var _help_data: Array[SD_ConsoleCommandHelp]

var _private: bool = false

var _variant_type_string: String = ""
var _variant_type: int = -1

var _number_minmax_enabled: bool = false
var _number_min_value: float = 0
var _number_max_value: float = 0

var _deinited: bool = false

var _networked: bool = false
var _server_authorative: bool = true

signal updated()
signal executed()

func is_networked() -> bool:
	return _networked

func set_networked(value: bool = true, server_authorative: bool = true) -> SD_ConsoleCommand:
	_networked = value
	_server_authorative = server_authorative
	
	if value:
		SD_Network.singleton.net_console.register_command(self)
	else:
		SD_Network.singleton.net_console.unregister_command(self)
	
	return self

func get_console() -> SD_Console:
	return _console

static func get_or_create(code: String, value: Variant = "") -> SD_ConsoleCommand:
	return SimusDev.console.create_command(code, value)

func number_get_min_value() -> float:
	return _number_min_value

func number_get_max_value() -> float:
	return _number_max_value

func number_set_min_max_value(min: float, max: float) -> SD_ConsoleCommand:
	if not is_variant_type_number():
		return self
	
	_number_minmax_enabled = true
	_number_min_value = min
	_number_max_value = max
	
	_number_update_minmax()
	return self

func _number_update_minmax() -> void:
	if not _number_minmax_enabled:
		return
	
	var cur_float: float = get_value_as_float()
	
	if cur_float > _number_max_value:
		set_value(_number_max_value)
	if cur_float < _number_min_value:
		set_value(_number_min_value)


func _number_get_clamped_value(from: float) -> float:
	var clamped: float = clamp(from, _number_min_value, _number_max_value)
	return clamped

func is_variant_type_number() -> bool:
	return (_variant_type == TYPE_FLOAT) or (_variant_type == TYPE_INT)

func get_variant_type() -> int:
	return _variant_type

func get_variant_type_string() -> String:
	return _variant_type_string

func deinit() -> void:
	_deinited = true
	_console.remove_command(self)

func init(console: SD_Console, settings: SD_Settings, cmd_code: String, cmd_value: Variant) -> void:
	_console = console
	_settings = settings
	_code = cmd_code.replacen(" ", "")
	_value = str(cmd_value)
	if cmd_value == null:
		_value = ""
		
	
	var variant: Variant = str_to_var(_value)
	_variant_type = typeof(variant)
	_variant_type_string = type_string(_variant_type)
	
	
	if _variant_type_string == "Nil":
		_variant_type_string = "String"
		_variant_type = TYPE_STRING
	
	_settings.add_setting(get_code(), get_value())
	_value = _settings.get_setting_value(get_code(), "")
	
	updated.emit()
	update_command()

func execute(args: Array[String] = []) -> void:
	_arguments = args.duplicate()
	if !args.is_empty():
		var value: String = ""
		
		for id in args.size():
			var i: String = args[id]
			value += i
			
			if !id == args.size() - 1:
				value += " "
		
		set_value(value)
	
	executed.emit()
	
	if _networked:
		SD_Network.singleton.net_console.execute_command(self, args, true)

func is_private() -> bool:
	return _private

func set_private(value: bool = true) -> SD_ConsoleCommand:
	_private = value
	return self

func is_value_invalid() -> bool:
	return _value.is_empty()

func get_arguments() -> Array[String]:
	return _arguments

func get_argument(index: int = 0) -> String:
	return SD_Array.get_value_from_array(_arguments, index, "")

func set_value(value: Variant, update: bool = true) -> void:
	_value = str(value)
	_number_update_minmax()
	
	if get_variant_type() == TYPE_INT:
		_value = str(int(get_value_as_string()))
	
	_settings.change_setting(get_code(), get_value())
	
	if update:
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

func get_value_as_array() -> Array:
	var parsed: Variant = str_to_var(_value)
	if parsed is Array:
		return parsed
	return []

func get_value_as_dictionary() -> Dictionary:
	var parsed: Variant = str_to_var(_value)
	if parsed is Dictionary:
		return parsed
	return {}

func get_value_as_vector2() -> Vector2:
	var parsed: Variant = str_to_var("Vector2" + _value)
	if parsed is Vector2:
		return parsed
	return Vector2.ZERO

func get_value_as_vector3() -> Vector3:
	var parsed: Variant = str_to_var("Vector3" + _value)
	if parsed is Vector3:
		return parsed
	return Vector3.ZERO

func get_value_as_variant() -> Variant:
	if get_variant_type_string() == "String":
		var parsed: String = "'%s'" % _value
		return str_to_var(parsed)
	return str_to_var(_value)

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
