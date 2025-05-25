extends SD_NodeConsole
class_name SD_NodeConsoleCommands

@export var commands: Array[SD_NodeCommandObject] = []

signal on_executed(command: SD_ConsoleCommand)

func _ready() -> void:
	for cmd_obj in commands:
		if cmd_obj:
			var cmd := console.create_command(cmd_obj.code, cmd_obj.value)
			cmd.executed.connect(__on_executed.bind(cmd))

func __on_executed(cmd: SD_ConsoleCommand) -> void:
	on_executed.emit(cmd)
