@icon("res://addons/simusdev/icons/GroupViewport.svg")
extends Node
class_name SD_FiniteStateMachine

@export var server_authority: bool = false
@export var _initial_state: SD_FiniteState

@onready var _console: SD_TrunkConsole = SimusDev.console

var _states: Dictionary[String, SD_FiniteState] = {}
var _states_by_id: Dictionary[int, SD_FiniteState] = {}
var _state_list: Array[SD_FiniteState] = []

var _state: SD_FiniteState

signal state_enter(state: SD_FiniteState)
signal state_exit(state: SD_FiniteState)
signal transitioned(to: SD_FiniteState, from: SD_FiniteState)

var _network: SD_NetworkFunctionCaller

func get_state() -> SD_FiniteState:
	return _state

func create_state(state: String) -> SD_FiniteState:
	if _states.has(state):
		_console.write_from_object(self, "cant create state '%s' that already exists!", SD_ConsoleCategories.ERROR)
		return null
	
	var fstate: SD_FiniteState = SD_FiniteState.new()
	fstate.name = state.validate_node_name()
	
	_states[fstate.name] = fstate
	_states_by_id[_states_by_id.size()] = fstate
	_state_list.append(fstate)
	
	add_child(fstate)
	
	if not _initial_state and not get_state():
		_try_transition(fstate)
	
	return fstate

func remove_state(state: SD_FiniteState) -> void:
	if _state_list.has(state):
		_state_list.erase(state)
		_states.erase(state.name)
		_states_by_id.erase(state.get_id())
		state.queue_free()
		

func _ready() -> void:
	_network = SD_NetworkFunctionCaller.new("fsm")
	
	SD_Network.register_functions(
		[
			_send_,
			_transition_requested_net,
		]
	)
	
	for child in get_children():
		if child is SD_FiniteState:
			create_state(child.name)
	
	
	
	_network.call_func_on_server(_send_)

func _send_() -> void:
	if get_state():
		_network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_, [get_state().get_id()])

func _recieve_(state_id: int) -> void:
	_try_transition(get_state_by_id(state_id))

func get_state_by_name(state_name: String) -> SD_FiniteState:
	return _states.get(state_name)

func get_state_by_id(state_id: int) -> SD_FiniteState:
	var id: int = 0
	for state_name in _states:
		if state_id == id:
			return _states[state_name]
		id += 1
	return null

func _transition_requested(state: SD_FiniteState) -> void:
	if server_authority:
		if SD_Network.is_server():
			_network.call_func(_transition_requested_net, [state.get_id()])
			return
		return
	
	
	
	if SD_Network.is_authority(self):
		_network.call_func(_transition_requested_net, [state.get_id()])

func _transition_requested_net(state_id: int) -> void:
	if get_multiplayer_authority() != SD_Network.get_remote_sender_id():
		return
	
	var state: SD_FiniteState = get_state_by_id(state_id)
	if state.enabled:
		_try_transition(state)

func _try_transition(state: SD_FiniteState) -> void:
	if get_state() == state:
		return
	
	if !_state_list.has(state):
		return
	
	var last_state: SD_FiniteState = get_state()
	if last_state:
		last_state._exit()
		last_state.on_exit.emit()
		last_state._set_state_processing(false)
		state_exit.emit(last_state)
	
	var new_state: SD_FiniteState = state
	_state = new_state
	
	new_state._enter()
	new_state.on_enter.emit()
	new_state._set_state_processing(true)
	state_enter.emit(new_state)
	
	transitioned.emit(last_state, new_state)
	

func switch(to: SD_FiniteState) -> SD_FiniteState:
	if !to:
		return
	
	if !_state_list.has(to):
		return
	
	to.transition()
	return to

func switch_by_name(state_name: String) -> SD_FiniteState:
	return switch(get_state_by_name(state_name))

func switch_by_id(id: int) -> SD_FiniteState:
	return switch(get_state_by_id(id))
