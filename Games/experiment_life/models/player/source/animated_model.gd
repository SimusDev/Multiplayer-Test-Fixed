@tool
extends W_AnimatedModel3D

@export var _movement: W_FPCSourceLikeMovement

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_movement.state_machine.transitioned.connect(_on_state_machine_transitioned)
	
	update_from_state(_movement.state_machine.get_current_state())

func update_from_state(state: SD_State) -> void:
	if not state:
		return
	
	match state.name:
		"walk":
			pass

func _on_state_machine_transitioned(from: SD_State, to: SD_State) -> void:
	update_from_state(to)
