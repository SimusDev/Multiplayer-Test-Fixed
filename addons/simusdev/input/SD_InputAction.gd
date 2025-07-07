extends SD_Object
class_name SD_InputAction

var _cmd: SD_ConsoleCommand

func _init(trunk: SD_TrunkInput, action: String) -> void:
	return
	
	if not InputMap.has_action(action) or action.begins_with("ui_"):
		return
	
	_cmd = SD_ConsoleCommand.get_or_create("input.action.events.%s" % action, InputMap.action_get_events(action)).set_private()
	
	
	
