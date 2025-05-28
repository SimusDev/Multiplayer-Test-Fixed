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
