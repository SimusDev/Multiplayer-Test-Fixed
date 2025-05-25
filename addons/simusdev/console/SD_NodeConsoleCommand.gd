extends SD_NodeConsole
class_name SD_NodeConsoleCommand

@export var command: SD_NodeCommandObject

signal on_executed(command: SD_ConsoleCommand)

func _ready() -> void:
	if command:
		var cmd := console.create_command(command.code, command.value)
		cmd.executed.connect(__on_executed.bind(cmd))

func __on_executed(cmd: SD_ConsoleCommand) -> void:
	on_executed.emit(cmd)
