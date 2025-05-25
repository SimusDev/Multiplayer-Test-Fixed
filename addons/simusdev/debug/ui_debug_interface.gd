extends CanvasLayer

@onready var console: SD_TrunkConsole = SimusDev.console

@export var debug_interface_scene: PackedScene

var _debug_interface_instance: CanvasLayer = null

func _ready() -> void:
	var commands: Array[SD_ConsoleCommand] = [
		console.create_command("debug.interface", false)
	]
	
	for cmd in commands:
		cmd.updated.connect(_on_command_updated.bind(cmd))
		cmd.update_command()

func _update_debug_interface(cmd: SD_ConsoleCommand) -> void:
	if _debug_interface_instance == null and cmd.get_value_as_bool():
		_debug_interface_instance = debug_interface_scene.instantiate()
		add_child(_debug_interface_instance)
	
	if _debug_interface_instance and not cmd.get_value_as_bool():
		_debug_interface_instance.queue_free()
		_debug_interface_instance = null

func _on_command_updated(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"debug.interface":
			_update_debug_interface(cmd)
