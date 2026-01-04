extends SD_Trunk
class_name SD_TrunkGame

var _pause_priority: int = 0

var pause_when_minimized: bool = false

var _gamesettings: SD_NodeGameSettingsSingleton

func get_window() -> SD_TrunkWindow:
	return SimusDev.window

func get_console() -> SD_TrunkConsole:
	return SimusDev.console

func _ready() -> void:
	var console: SD_TrunkConsole = SimusDev.console
	
	if Engine.is_editor_hint():
		return
	
	var _commands: Array[SD_ConsoleCommand] = [
		console.create_command("game.pause.priority"),
		console.create_command("game.change_scene_to_file")
		]
	
	for cmd in _commands:
		cmd.updated.connect(_on_command_updated.bind(cmd))
		cmd.executed.connect(_on_command_executed.bind(cmd))
		cmd.update_command()
	
	get_window().focused_in.connect(func(): if pause_when_minimized: pause_subtract_priority())
	get_window().focused_out.connect(func(): if pause_when_minimized: pause_add_priority())
	
	var settings: Dictionary = SimusDev.get_settings().game
	_gamesettings = SD_NodeGameSettingsSingleton.new()
	
	_gamesettings.minimize_feature = settings.minimize_feature
	_gamesettings.mute_audio_when_minimized = settings.mute_audio_when_minimized
	_gamesettings.pause_when_minimized = settings.pause_when_minimized
	
	SimusDev.add_child(_gamesettings)
	_gamesettings.name = "SD_NodeGameSettingsSingleton"
	

func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"game.pause.priority":
			pause_set_priority(cmd.get_value_as_int())

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"game.change_scene_to_file":
			var path: String = cmd.get_value_as_string()
			if path.is_empty():
				get_console().write_error("you have to specify the path (example: res://scenes/game.tscn)")
				return
			get_console().write_info("trying to change scene to...: %s" % [path])
			var err: int = SimusDev.get_tree().change_scene_to_file(path)
			if err == OK:
				get_console().write_success("game scene changed to: %s" % [path])
			else:
				get_console().write_error("game scene failed change to: %s" % [path])


func pause_set_priority(priority: int) -> void:
	_pause_priority = priority
	
	if _pause_priority < 0:
		_pause_priority = 0
	
	SimusDev.get_tree().paused = bool(_pause_priority)

func pause_add_priority() -> void:
	pause_set_priority(pause_get_priority() + 1)

func pause_subtract_priority() -> void:
	pause_set_priority(pause_get_priority() - 1)

func pause_get_priority() -> int:
	return _pause_priority


static func get_node_all_children(node: Node) -> Array[Node]:
	var children: Array[Node] = []
	
	for child in node.get_children():
		children.append(child)
		children.append_array(get_node_all_children(child))
	
	return children
