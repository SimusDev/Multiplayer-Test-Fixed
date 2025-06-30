extends Resource
class_name SD_NodeCommandObject

@export var update_at_start: bool = true
@export var code: String = "my_command"
@export var value: String = ""
@export var private: bool = false
@export var binds: Array[SD_NodeCommandObjectBind] = []

var source: SD_ConsoleCommand
var root: Node

func initialize() -> SD_ConsoleCommand:
	source = SimusDev.console.create_command(code, value)
	source.set_private(private)
	
	for bind in binds:
		bind.initialize(self)
	
	if update_at_start: source.update_command()
	return source
