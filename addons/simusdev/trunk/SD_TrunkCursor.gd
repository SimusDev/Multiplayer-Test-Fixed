extends SD_Trunk
class_name SD_TrunkCursor

signal mode_changed()

const MODE_VISIBLE: int = Input.MouseMode.MOUSE_MODE_VISIBLE
const MODE_HIDDEN: int = Input.MouseMode.MOUSE_MODE_HIDDEN
const MODE_CAPTURED: int = Input.MouseMode.MOUSE_MODE_CAPTURED
const MODE_CONFINED: int = Input.MouseMode.MOUSE_MODE_CONFINED
const MODE_CONFINED_HIDDEN: int = Input.MouseMode.MOUSE_MODE_CONFINED_HIDDEN
const MODE_MAX: int = Input.MouseMode.MOUSE_MODE_MAX

enum MODE {
	VISIBLE,
	HIDDEN,
	CAPTURED,
	CONFINED,
	CONFINED_HIDDEN,
	MAX,
}

var _node: SD_NodeCursor = null

func _ready() -> void:
	var custom_scene: PackedScene = SimusDev.get_settings().custom_cursor_node
	if custom_scene:
		var node: SD_NodeCursor = SD_NodeCursor.new()
		apply_cursor_node(node)
		node.add_child(custom_scene.instantiate())
		SimusDev.canvas.get_last_layer().add_child(node)
	
	var commands: Array[SD_ConsoleCommand] = [
		SimusDev.console.create_command("cursor.reset_mode"),
		SimusDev.console.create_command("cursor.set_mode"),
	]
	
	for cmd in commands:
		cmd.executed.connect(_on_command_executed.bind(cmd))
		cmd.update_command()

func _on_command_executed(cmd: SD_ConsoleCommand) -> void:
	match cmd.get_code():
		"cursor.reset_mode":
			reset_mode()
		"cursor.set_mode":
			set_mode(cmd.get_value_as_int())

func reset_mode() -> void:
	set_mode(MODE.VISIBLE)

func set_mode(mode: MODE) -> void:
	var mouse_mode: int = int(mode)
	
	if _node:
		if mouse_mode == MODE.VISIBLE:
			mouse_mode = MODE.HIDDEN
		
		
	
	Input.set_mouse_mode(mouse_mode)
	mode_changed.emit()

func get_mode() -> int:
	return Input.mouse_mode

func apply_cursor_node(node: SD_NodeCursor) -> void:
	_node = node
	set_mode(int(Input.mouse_mode))

func get_node() -> SD_NodeCursor:
	return _node
