extends SD_EventBus
class_name SD_TrunkEventBus

var DEBUG: bool = false

func _ready() -> void:
	var console := SimusDev.console as SD_TrunkConsole
	console.on_command_updated.connect(_on_command_updated)
	console.create_command("events.debug", true)


func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"events.debug":
			var console := SimusDev.console as SD_TrunkConsole
			DEBUG = cmd.get_value_as_bool()
