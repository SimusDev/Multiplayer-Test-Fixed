extends Resource
class_name SD_ConsoleNodeCommandObjectStorage

@export var list: Array[SD_NodeCommandObject] = []

var _cmd_list: Array[SD_ConsoleCommand] = []

func initialize() -> void:
	for object in list:
		if object:
			object.initialize()
		
		
		_cmd_list.append(object.source)
	
	

func deinitialize() -> void:
	for cmd in _cmd_list:
		cmd.deinit()

func get_command_list() -> Array[SD_ConsoleCommand]:
	return _cmd_list
