extends Node

signal interface_opened(node: Node)
signal interface_closed(node: Node)

var _active_interfaces: Array[Node]

@export var CLOSE_LAST_INTERFACE_ACTION: String = "close_interface"

@export var _active_input: SD_NodeInput
@export var _inactive_input: SD_NodeInput
@export var _input_close: SD_NodeInput

func get_active_input() -> SD_NodeInput:
	return _active_input

func get_inactive_input() -> SD_NodeInput:
	return _inactive_input

func _update_UI() -> void:
	_inactive_input.enabled = not SimusDev.ui.has_active_interface()
	
	_active_input.update_input_status()
	_input_close.update_input_status()

func _ready() -> void:
	SimusDev.ui.interface_opened_or_closed.connect(_on_interface_opened_or_closed)
	_update_UI()

func _on_interface_opened_or_closed(i: Node, status: bool) -> void:
	_update_UI()
