extends SD_Trunk
class_name SD_TrunkUI

signal interface_opened(node: Node)
signal interface_closed(node: Node)

signal interface_opened_or_closed(node: Node, status: bool)

var _active_interfaces: Array[Node]

const ACTION_CLOSE_MENU: String = "sd_ui_close_menu"

var command_dynamic_size: SD_ConsoleCommand

func _ready() -> void:
	command_dynamic_size = SimusDev.console.create_command("ui.dynamic.size", 1.0)
	var min: float = SimusDev.get_settings().ui.get("dynamic_size_min", 0.5)
	var max: float = SimusDev.get_settings().ui.get("dynamic_size_max", 1.0)
	
	command_dynamic_size.number_set_min_max_value(min, max)
	
	InputMap.add_action(ACTION_CLOSE_MENU)
	
	var event: InputEventKey = InputEventKey.new()
	event.keycode = KEY_ESCAPE
	InputMap.action_add_event(ACTION_CLOSE_MENU, event)

func open_interface(node: Node) -> void:
	if _active_interfaces.has(node):
		return
	
	_active_interfaces.append(node)
	interface_opened.emit(node)
	interface_opened_or_closed.emit(node, true)
	_update_UI()

func close_interface(node: Node) -> void:
	if not _active_interfaces.has(node):
		return
	
	_active_interfaces.erase(node)
	interface_closed.emit(node)
	interface_opened_or_closed.emit(node, false)
	_update_UI()

func close_last_interface() -> void:
	if has_active_interface():
		close_interface(get_last_interface())

func get_last_interface() -> Node:
	if has_active_interface():
		var last: Node = _active_interfaces[_active_interfaces.size() - 1]
		return last
	return null

func has_active_interface() -> bool:
	return not _active_interfaces.is_empty()

func is_interface_active(node: Node) -> bool:
	return _active_interfaces.has(node)

func get_active_interfaces() -> Array[Node]:
	return _active_interfaces

func _update_UI() -> void:
	pass
