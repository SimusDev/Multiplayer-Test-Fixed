@tool
extends W_AnimatedModel3D

@export var _movement: W_FPCSourceLikeMovement

func _ready() -> void:
	if !_movement:
		set_process(false)
		set_physics_process(false)
		return
	
	_movement.state_machine.state_enter.connect(_on_state_enter)
	_on_state_enter(_movement.state_machine.get_current_state())
	

func _on_state_enter(state: SD_State) -> void:
	match state.name:
		"ground":
			pass
