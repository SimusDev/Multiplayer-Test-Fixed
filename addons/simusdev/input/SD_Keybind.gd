extends SD_Object
class_name SD_Keybind

var _code: String = ""
var _unique_code: String = ""
var _action: String = ""
var _key: String = ""

var _cmd: SD_ConsoleCommand

func _init(code: String, key: String, built_in: bool = false) -> void:
	var console: SD_TrunkConsole = SimusDev.console
	
	_unique_code = SD_Input.PREFIX_BIND + code
	_action = SD_Input.PREFIX_BIND + code
	if built_in:
		_action = code
	
	if not InputMap.has_action(_action):
		InputMap.add_action(_action)
	_key = key
	_code = code
	_cmd = console.create_command(_unique_code, key)
	_cmd.updated.connect(_on_cmd_updated)
	_on_cmd_updated()

func deinit() -> void:
	InputMap.erase_action(_action)
	_cmd.deinit()

func _on_cmd_updated() -> void:
	_key = _cmd.get_value()
	
	InputMap.action_erase_events(_action)
	for event in SD_InputDispatcher.from_string(_key):
		InputMap.action_add_event(_action, event)

func set_key(key: String) -> void:
	_cmd.set_value(key)

func get_key() -> String:
	return _key

func is_pressed() -> bool:
	return Input.is_action_pressed(_action)

func is_just_pressed() -> bool:
	return Input.is_action_just_pressed(_action)

func is_just_released() -> bool:
	return Input.is_action_just_released(_action)

func get_code() -> String:
	return _code
