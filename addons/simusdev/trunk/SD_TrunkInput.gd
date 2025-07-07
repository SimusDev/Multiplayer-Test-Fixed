extends SD_Trunk
class_name SD_TrunkInput

var _actions: Dictionary[String, SD_InputAction] = {}

func _ready() -> void:
	_parse_actions()

func _parse_actions() -> void:
	for action in InputMap.get_actions():
		_actions[action] = SD_InputAction.new(self, action)
