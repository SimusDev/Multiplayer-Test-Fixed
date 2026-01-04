extends SD_Console
class_name SD_TrunkConsole

var _console_prefab: PackedScene = preload("res://addons/simusdev/console/prefabs/ui_console_new.tscn")
var _debug_prefab: PackedScene = preload("res://addons/simusdev/debug/ui_debug_interface.tscn")

var _console_node: Node = null
var _debug_node: Node = null

const SETTINGS_PATH: String = "console.ini"
const SETTINGS_PATH_EDITOR: String = "console_editor.ini"

var can_open_or_close: bool = true : set = set_can_open_or_close

signal visibility_changed()

func is_visible() -> bool:
	return _console_node.is_visible()

func set_visible(value: bool) -> void:
	_console_node.set_visible(value)

func set_can_open_or_close(value: bool) -> void:
	_console_node.can_open_or_close = value

func _ready() -> void:
	_instance = self
	
	if Engine.is_editor_hint():
		initialize(SETTINGS_PATH_EDITOR)
	else:
		initialize(SETTINGS_PATH)
	
	initialize_engine_settings()
	
	gd_print = SimusDev.get_settings().console.gd_print
	
	_console_node = _console_prefab.instantiate()
	
	if _console_node is CanvasItem:
		_console_node.visible = false
	
	_debug_node = _debug_prefab.instantiate()
	
	if !Engine.is_editor_hint():
		var canvas: CanvasLayer = SimusDev.canvas.get_layer(0)
		canvas.add_child(_console_node)
		canvas.add_child(_debug_node)
	
	var exec_commands: Array[SD_ConsoleCommand] = [
		create_command("cmd.list"),
	]
	
	for cmd in exec_commands:
		cmd.executed.connect(_on_cmd_executed.bind(cmd))
	
	SD_ConsoleCategories._register_builtin()

func _on_cmd_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"cmd.list":
			print_command_list()

func print_command_list() -> void:
	var list: String = ""
	for cmd in get_commands_list():
		var cmd_info: String = "%s = %s (def. %s)" % [cmd.get_code(), cmd.get_value_as_string(), _settings.get_default_setting_value(cmd.get_code())]
		list += cmd_info
		list += "\n"
	
	write_info(list)

func initialize_engine_settings() -> void:
	var storage: SD_ConsoleNodeCommandObjectStorage = SimusDev.get_settings().commands
	if !storage:
		return
	
	storage.initialize()
