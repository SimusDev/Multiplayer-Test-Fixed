extends Resource
class_name SD_NodeCommandObject

@export var update_at_start: bool = true
@export var code: String = "my_command"
@export var value: String = ""
@export var private: bool = false
@export var binds: Array[SD_NodeCommandObjectBind] = []

@export var number_min_value: float = 0
@export var number_max_value: float = 0

var source: SD_ConsoleCommand
var root: Node

func initialize() -> SD_ConsoleCommand:
	source = SimusDev.console.create_command(code, value)
	source.set_private(private)
	
	if not (number_min_value == 0 and number_max_value == 0):
		source.number_set_min_max_value(number_min_value, number_max_value)
	
	for bind in binds:
		bind.initialize(self)
	
	if update_at_start: source.update_command()
	return source

func deinitialize() -> void:
	if not source:
		return
	
	source.deinit()
