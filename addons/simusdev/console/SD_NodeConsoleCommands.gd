extends SD_NodeConsole
class_name SD_NodeConsoleCommands

@export var commands: Array[SD_NodeCommandObject] = []

signal on_executed(command: SD_ConsoleCommand)

func _ready() -> void:
	super()
	
	for cmd_obj in commands:
		if cmd_obj:
			cmd_obj.root = self
			var cmd := cmd_obj.initialize()
			cmd.executed.connect(__on_executed.bind(cmd))

func __on_executed(cmd: SD_ConsoleCommand) -> void:
	on_executed.emit(cmd)
