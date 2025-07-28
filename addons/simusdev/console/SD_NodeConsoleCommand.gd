extends SD_NodeConsole
class_name SD_NodeConsoleCommand

@export var command: SD_NodeCommandObject

signal on_executed(command: SD_ConsoleCommand)
signal on_updated(command: SD_ConsoleCommand)

var _cmd: SD_ConsoleCommand

func _ready() -> void:
	super()
	
	if command:
		command.root = self
		_cmd = command.initialize()
		_cmd.executed.connect(__on_executed.bind(_cmd))
		_cmd.updated.connect(__on_updated.bind(_cmd))

func __on_executed(cmd: SD_ConsoleCommand) -> void:
	on_executed.emit(cmd)

func __on_updated(cmd: SD_ConsoleCommand) -> void:
	on_updated.emit(cmd)

func get_command() -> SD_ConsoleCommand:
	return _cmd as SD_ConsoleCommand
