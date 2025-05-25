extends SD_Object
class_name SD_Input

const PREFIX_BIND: String = "bind."
const PREFIX_KEY: String = "key."
const PREFIX_MOUSE: String = "mouse"

static func get_input_map_builtin_actions() -> Array[String]:
	var result: Array[String] = []
	var actions: Array[StringName] = InputMap.get_actions()
	for i in actions:
		if i.begins_with("ui_"):
			result.append(i)
	return result

static func get_input_map_user_actions() -> Array[String]:
	var result: Array[String] = []
	var actions: Array[StringName] = InputMap.get_actions()
	for i in actions:
		if !i.begins_with("ui_"):
			result.append(i)
	return result

static func is_action_keybind(action: String) -> bool:
	return action.begins_with(PREFIX_BIND)
