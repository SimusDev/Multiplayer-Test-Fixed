@tool
extends SD_Localization
class_name SD_TrunkLocalization

var _cmd_localization: SD_ConsoleCommand

func _ready() -> void:
	var settings: SD_EngineSettings = SimusDev.get_settings()
	#settings.set_localization_resources(settings.localization_resources.duplicate())
	
	_flags = settings.localization_flags
	_unique_names = settings.localization_language_unique_name
	
	var console: SD_TrunkConsole = SimusDev.console
	
	var picked_loc: String = OS.get_locale_language()
	if !get_available_languages().has(picked_loc):
		picked_loc = "en"
	
	_cmd_localization = console.create_command("localization", picked_loc)
	_cmd_localization.updated.connect(_on_command_updated.bind(_cmd_localization))
	
	_on_command_updated(_cmd_localization)

func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	var language: String = cmd.get_value()
	_current_language = language
	update_localization()

func get_command() -> SD_ConsoleCommand:
	return _cmd_localization

func set_current_languge(language: String) -> void:
	_current_language = language
	_cmd_localization.set_value(language)
	
