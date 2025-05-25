@tool
extends SD_Localization
class_name SD_TrunkLocalization

var _cmd_localization: SD_ConsoleCommand

func _ready() -> void:
	var console: SD_TrunkConsole = SimusDev.console
	_cmd_localization = console.create_command("localization", "null")
	_cmd_localization.updated.connect(_on_command_updated.bind(_cmd_localization))
	
	_on_command_updated(_cmd_localization)

func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	var language: String = cmd.get_value()
	_current_language = language
	update_localization()

func set_current_languge(language: String) -> void:
	_current_language = language
	_cmd_localization.set_value(language)
	
