extends Control

@onready var _base: SD_TrunkConsole = SimusDev.console

func _ready() -> void:
	var upd_commands: Array[SD_ConsoleCommand] = [
		_base.create_command("ui.console.zoom", 1.0),
		_base.create_command("ui.console.position", Vector2(0, 0)),
	]
	
	for cmd in upd_commands:
		cmd.updated.connect(_on_command_updated.bind(cmd))
		cmd.update_command()
	

func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		pass
