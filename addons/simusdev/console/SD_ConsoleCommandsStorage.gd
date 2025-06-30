extends Resource
class_name SD_ConsoleNodeCommandObjectStorage

@export var list: Array[SD_NodeCommandObject] = []

func initialize() -> void:
	for object in list:
		if object:
			object.initialize()
