extends SD_Console
class_name SD_TrunkConsole

var _console_prefab: PackedScene = preload("res://addons/simusdev/console/prefabs/ui_console_new.tscn")
var _debug_prefab: PackedScene = preload("res://addons/simusdev/debug/ui_debug_interface.tscn")

var _console_node: Node = null
var _debug_node: Node = null

const SETTINGS_PATH: String = "console.ini"

var can_open_or_close: bool = true : set = set_can_open_or_close

signal visibility_changed()

func is_visible() -> bool:
	return _console_node.is_visible()

func set_visible(value: bool) -> void:
	_console_node.set_visible(value)

func set_can_open_or_close(value: bool) -> void:
	_console_node.can_open_or_close = value

func _ready() -> void:
	initialize(SETTINGS_PATH)
	initialize_engine_settings()
	
	gd_print = SimusDev.get_settings().console.gd_print
	
	_console_node = _console_prefab.instantiate()
	
	if _console_node is CanvasItem:
		_console_node.visible = false
	
	_debug_node = _debug_prefab.instantiate()
	
	var canvas: CanvasLayer = SimusDev.canvas.get_layer(0)
	canvas.add_child(_console_node)
	canvas.add_child(_debug_node)

func initialize_engine_settings() -> void:
	var storage: SD_ConsoleNodeCommandObjectStorage = SimusDev.get_settings().commands
	if !storage:
		return
	
	storage.initialize()
