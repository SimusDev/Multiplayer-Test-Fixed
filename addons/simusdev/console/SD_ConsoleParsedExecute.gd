extends SD_Object
class_name SD_ConsoleParsedExecute

var _code: String
var _value = null
var _arguments: Array[String]

func _init(execute) -> void:
	var string: String = str(execute)
	var splitted := string.split(" ", false)
	for arg in splitted:
		_arguments.append(str(arg))
	
	if _arguments.is_empty():
		return
	
	_code = _arguments[0]
	_arguments.remove_at(0)
	if !_arguments.is_empty():
		_value = _arguments[0]
	
	
	

func is_valid() -> bool:
	return !is_invalid()

func is_invalid() -> bool:
	return _code.is_empty()

func get_code() -> String:
	return _code

func get_value_as_string() -> String:
	return str(_value)

func get_arguments() -> Array[String]:
	return _arguments
