@tool
@icon("res://addons/simusdev/icons/Groups.svg")
extends Node
class_name SD_State

@export var id: String

var _state_machine: SD_NodeStateMachine

signal transitioned()

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_switch_synchronized,
	])
	
	if Engine.is_editor_hint():
		process_mode = Node.PROCESS_MODE_DISABLED

static func create(state_id: String) -> SD_State:
	var state := SD_State.new()
	state.id = state_id
	return state

func switch() -> void:
	SD_Network.call_func(_switch_synchronized)

func _switch_synchronized() -> void:
	transitioned.emit()

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func _update(delta: float) -> void:
	pass

func _physics_update(delta: float) -> void:
	pass

func _handle_input(event: InputEvent) -> void:
	pass

func get_machine() -> SD_NodeStateMachine:
	return _state_machine
