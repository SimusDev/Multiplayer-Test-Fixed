extends SD_SceneSaverLoader
class_name SRC_S_GameSaver

var _cmd_save: SD_ConsoleCommand
var _cmd_load: SD_ConsoleCommand

func _ready() -> void:
	_cmd_save = SD_ConsoleCommand.get_or_create("save")
	_cmd_load = SD_ConsoleCommand.get_or_create("load")
	
	_cmd_save.executed.connect(_on_save_executed.bind(_cmd_save))
	_cmd_load.executed.connect(_on_load_executed.bind(_cmd_load))
	
	_cmd_save.help_set("you must specify the file")
	_cmd_load.help_set("you must specify the file")
	

func _on_save_executed(cmd: SD_ConsoleCommand) -> void:
	if SD_Network.is_server():
		var save: String = cmd.get_value_as_string()
		save_scene(save)

func _on_load_executed(cmd: SD_ConsoleCommand) -> void:
	if SD_Network.is_server():
		var save: String = cmd.get_value_as_string()
		load_scene(save)
