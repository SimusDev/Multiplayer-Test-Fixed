extends Node
class_name SD_FiniteState

@onready var _machine: SD_FiniteStateMachine

@onready var _console: SD_TrunkConsole = SimusDev.console

func _ready() -> void:
	_machine = SD_Components.node_find_above_by_script(self, SD_FiniteStateMachine)
	
	if not _machine:
		_console.write_from_object(self, "finite state machine not found above!!!", SD_ConsoleCategories.ERROR)
		return

func transition() -> void:
	_machine._transition_requested(self)

func _enter() -> void:
	pass

func _exit() -> void:
	pass
