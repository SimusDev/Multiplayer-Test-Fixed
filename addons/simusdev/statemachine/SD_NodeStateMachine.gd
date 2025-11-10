@icon("res://addons/simusdev/icons/GroupViewport.svg")
extends Node
class_name SD_NodeStateMachine

@export var initial_state: SD_State
@export var network_channel: String = "state_machine"

var _states: Dictionary[String, SD_State] = {}
var _current_state: SD_State

var _current_state_name: String = ""

signal transitioned(from: SD_State, to: SD_State)
signal state_enter(state: SD_State)
signal state_exit(state: SD_State)

static func find(node: Node) -> SD_NodeStateMachine:
	return node.get_meta("SD_NodeStateMachine", null)

func get_current_state() -> SD_State:
	return _current_state

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		_send,
		_recieve,
	])
	
	for child in get_children():
		if child is SD_State:
			_states[child.name] = child
			child._state_machine = self
			child.transitioned.connect(_on_child_state_transitioned.bind(child))
	
	if initial_state:
		_current_state = initial_state
		_current_state._enter()
	
	if not SD_Network.is_server():
		SD_Network.call_func_on_server(_send)
		return
	

func _send() -> void:
	if is_instance_valid(_current_state):
		SD_Network.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [_current_state.get_index()], SD_Network.CALLMODE.RELIABLE, network_channel)

func _recieve(id: int) -> void:
	(get_child(id) as SD_State)._switch_synchronized()

func _on_child_state_transitioned(to_state: SD_State) -> void:
	if to_state == _current_state:
		return
	
	var prev_state: SD_State = _current_state
	
	if _current_state:
		_current_state._exit()
		state_exit.emit(_current_state)
	
	
	_current_state = to_state
	to_state._enter()
	state_enter.emit(to_state)
	
	transitioned.emit(prev_state, to_state)


func switch(to_state: SD_State) -> void:
	if !to_state:
		return
	
	if _current_state == to_state:
		return
	
	if to_state:
		to_state.switch()

func switch_by_name(state_name: String) -> SD_State: 
	var state: SD_State = get_state_by_name(state_name)
	switch(state)
	return state

func get_state_by_name(state_name: String) -> SD_State:
	return _states.get(state_name, null)
	
func _process(delta: float) -> void:
	if _current_state:
		_current_state._update(delta)

func _physics_process(delta: float) -> void:
	if _current_state:
		_current_state._physics_update(delta)

func _input(event: InputEvent) -> void:
	if _current_state:
		_current_state._handle_input(event)
