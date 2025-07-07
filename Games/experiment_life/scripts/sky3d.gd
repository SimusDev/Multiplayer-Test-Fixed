extends Node

func _ready() -> void:
	await get_parent().ready
	
	var _commands: Array[EL_ConCommand] = [
		EL_SModuleCommands.get_or_create("time", 8.0),
	]
	
	for cmd in _commands:
		cmd.get_source().updated.connect(_on_cmd_updated.bind(cmd))
		cmd.get_source().update_command()

func _on_cmd_updated(cmd: EL_ConCommand) -> void:
	match cmd.code:
		"time":
			get_parent().current_time = cmd.get_source().get_value_as_float()
