extends Node

signal interface_opened(node: Node)
signal interface_closed(node: Node)

var _active_interfaces: Array[Node]

@export var CLOSE_LAST_INTERFACE_ACTION: String = "close_interface"

@export var _active_input: SD_NodeInput
@export var _input_close: SD_NodeInput

func get_active_input() -> SD_NodeInput:
	return _active_input

func open_interface(node: Node) -> void:
	if _active_interfaces.has(node):
		return
	
	_active_interfaces.append(node)
	interface_opened.emit(node)
	_update_UI()

func close_interface(node: Node) -> void:
	if not _active_interfaces.has(node):
		return
	
	_active_interfaces.erase(node)
	interface_closed.emit(node)
	_update_UI()

func close_last_interface() -> void:
	if has_active_interface():
		var last: Node = _active_interfaces[_active_interfaces.size() - 1]
		close_interface(last)

func has_active_interface() -> bool:
	return not _active_interfaces.is_empty()

func is_interface_active(node: Node) -> bool:
	return _active_interfaces.has(node)

func _update_UI() -> void:
	_active_input.enabled = not has_active_interface()
	
	_active_input.update_input_status()
	_input_close.update_input_status()

func _on_sd_node_input_on_action_just_pressed(action: String, bind: SD_Keybind) -> void:
	if action == CLOSE_LAST_INTERFACE_ACTION:
		close_last_interface()
