extends Node

signal interface_opened(node: Node)
signal interface_closed(node: Node)

var _active_interfaces: Array[Node]

@export var CLOSE_LAST_INTERFACE_ACTION: String = "close_interface"

@export var _active_input: SD_NodeInput
@export var _input_close: SD_NodeInput

@export var canvas: CanvasLayer

func _on_server_disconnected() -> void:
	if SD_Network.is_server():
		return
	
	slike_popups.open_base_path("connection_terminated", canvas)

func has_active_interface() -> bool:
	return !_active_interfaces.is_empty()

func get_active_input() -> SD_NodeInput:
	return _active_input

func get_input_close() -> SD_NodeInput:
	return _input_close

func _update_UI() -> void:
	_active_input.enabled = not SimusDev.ui.has_active_interface()
	_input_close.enabled = SimusDev.ui.has_active_interface()
	
	_active_input.update_input_status()
	_input_close.update_input_status()

func _ready() -> void:
	SD_Network.singleton.on_server_disconnected.connect(_on_server_disconnected)
	SimusDev.ui.interface_opened_or_closed.connect(_on_interface_opened_or_closed)
	_update_UI()

func _on_interface_opened_or_closed(i: Node, status: bool) -> void:
	_update_UI()
