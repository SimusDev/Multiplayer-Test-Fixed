@icon("res://addons/simusdev/icons/Groups.svg")
extends Node
class_name SD_FiniteState

@export var enabled: bool = true

@onready var _machine: SD_FiniteStateMachine

@onready var _console: SD_TrunkConsole = SimusDev.console

signal on_enter()
signal on_exit()

func _ready() -> void:
	_machine = SD_Components.node_find_above_by_script(self, SD_FiniteStateMachine)
	
	if not _machine:
		_console.write_from_object(self, "finite state machine not found above!!!", SD_ConsoleCategories.ERROR)
		return
	
	_set_state_processing(_machine.get_state() == self)

func _set_state_processing(value: bool) -> void:
	set_process(value)
	set_physics_process(value)
	set_process_input(value)
	set_process_shortcut_input(value)
	set_process_unhandled_input(value)
	set_process_unhandled_key_input(value)

func transition() -> SD_FiniteState:
	if is_active():
		return
	
	_machine._transition_requested(self)
	return self

func switch() -> SD_FiniteState:
	transition()
	return self

func is_active() -> bool:
	return _machine.get_state() == self

func _enter() -> void:
	pass

func _exit() -> void:
	pass

func get_id() -> int:
	return _machine._states.keys().find(name)

func set_timeout(time: float, switch_back: SD_FiniteState) -> void:
	await get_tree().create_timer(time, false).timeout
	switch_back.transition()
