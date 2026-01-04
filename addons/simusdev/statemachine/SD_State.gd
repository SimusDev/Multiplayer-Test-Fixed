@tool
@icon("res://addons/simusdev/icons/Groups.svg")
extends Node
class_name SD_State

@export var id: String

var _state_machine: SD_NodeStateMachine

signal transitioned()

func _ready() -> void:
	_state_machine = get_parent()
	
	if !Engine.is_editor_hint():
		SD_Network.register_object(self)
		SD_Network.register_functions([
			_switch_net,
			_switch_synchronized,
		])
		
		SD_Network.register_channel(_state_machine.network_channel)
		
		if SD_Network.is_server():
			SD_Network.register_function(_switch_net)
	
	if Engine.is_editor_hint():
		process_mode = Node.PROCESS_MODE_DISABLED

static func create(state_id: String) -> SD_State:
	var state := SD_State.new()
	state.id = state_id
	return state

func switch() -> void:
	if SD_Network.is_authority(_state_machine):
		_switch_net()
		SD_Network.call_func_on_server(_switch_net, [], SD_Network.CALLMODE.RELIABLE, _state_machine.network_channel)

func _switch_net() -> void:
	if _state_machine.get_multiplayer_authority() == SD_Network.get_remote_sender_id():
		SD_Network.call_func(_switch_synchronized, [], SD_Network.CALLMODE.RELIABLE, _state_machine.network_channel)
	

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
