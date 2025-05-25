extends SD_Console
class_name SD_TrunkConsole

var _console_prefab: PackedScene = preload("res://addons/simusdev/console/prefabs/ui_console.tscn")
var _debug_prefab: PackedScene = preload("res://addons/simusdev/debug/ui_debug_interface.tscn")

var _console_node: CanvasLayer = null
var _debug_node: CanvasLayer = null

const SETTINGS_PATH: String = "console.ini"

var disable_console_on_release: bool = true

signal visibility_changed()

func is_visible() -> bool:
	return _console_node.visible

func _ready() -> void:
	initialize(SETTINGS_PATH)
	
	if SD_Platforms.has_debug_console_feature():
		_console_node = _console_prefab.instantiate()
		_console_node.visible = false
		
		_debug_node = _debug_prefab.instantiate()
		
		var canvas: CanvasLayer = SimusDev.canvas.get_last_layer()
		canvas.add_child(_console_node)
		canvas.add_child(_debug_node)
	
