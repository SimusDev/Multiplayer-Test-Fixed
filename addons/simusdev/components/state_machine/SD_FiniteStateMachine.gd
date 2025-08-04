extends Node
class_name SD_FiniteStateMachine

@export var server_authority: bool = false
@export var _initial_state: SD_FiniteState

@onready var _console: SD_TrunkConsole = SimusDev.console

var _states: Dictionary[String, SD_FiniteState] = {}

var _state: SD_FiniteState

signal state_enter(state: SD_FiniteState)
signal state_exit(state: SD_FiniteState)
signal transitioned(to: SD_FiniteState, from: SD_FiniteState)

func get_state() -> SD_FiniteState:
	return _state

func _ready() -> void:
	SD_Network.register_functions(
		[
			_send_,
			_transition_requested_net,
		]
	)
	
	
	for child in get_children():
		if child is SD_FiniteState:
			_states[child.name] = child
	
	if SD_Network.is_server():
		if not _initial_state:
			if not _states.is_empty():
				_initial_state = _states.values()[0]
		
		if _initial_state:
			_initial_state.transition()
		else:
			_console.write_from_object(self, "initial state not found!", SD_ConsoleCategories.CATEGORY.ERROR)
		
		return
	
	SD_Network.call_func_on_server(_send_)

func _send_() -> void:
	if get_state():
		SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve_, [_state.name])

func _recieve_(state_name: String) -> void:
	switch_by_name(state_name)

func _transition_requested(state: SD_FiniteState) -> void:
	if server_authority and not SD_Network.is_server():
		return
	
	SD_Network.call_func_on_server(_transition_requested_net, [state.name])

func _transition_requested_net(state_name: String) -> void:
	if server_authority:
		return
	
	if get_multiplayer_authority() == SD_Network.get_remote_sender_id():
		SD_Network.call_func(_transition, [state_name])

func get_state_by_name(state_name: String) -> SD_FiniteState:
	return _states.get(state_name)

func switch(state: SD_FiniteState) -> void:
	if state._machine == self:
		state.transition()

func switch_by_name(state_name: String) -> void:
	var state: SD_FiniteState = get_state_by_name(state_name)
	if state:
		state.transition()
		return
	
	_console.write_from_object(self, "cant switch state by name, state not found: %s" % [state_name], SD_ConsoleCategories.ERROR)

func _transition(state_name: String) -> void:
	var new_state: SD_FiniteState = get_state_by_name(state_name)
	var cur_state: SD_FiniteState = get_state()
	
	if cur_state == new_state:
		return
	
	if cur_state:
		cur_state._exit()
	
	state_exit.emit(cur_state)
	
	_state = new_state
	
	new_state._enter()
	state_enter.emit(new_state)
	
	transitioned.emit(new_state, cur_state)
