extends Node
class_name SB_PlayerAnimator

@export var _movement: W_FPCSourceLikeMovement
@export var _skin: SB_EntitySkin

var _model: W_AnimatedModel3D

func _ready() -> void:
	if SD_Network.is_dedicated_server():
		return
	
	if !_skin.is_node_ready():
		await _skin.ready
	
	_movement.state_machine.state_enter.connect(_on_state_enter)
	_skin.updated.connect(_on_skin_updated)
	
	_on_skin_updated()

func _on_skin_updated() -> void:
	var source: Node3D = _skin.get_skin_node()
	if not is_instance_valid(source):
		_model = null
		return
	
	process_mode = Node.PROCESS_MODE_DISABLED
	
	if source is W_AnimatedModel3D:
		_model = source
		process_mode = Node.PROCESS_MODE_INHERIT
	
	_on_state_enter(_movement.get_current_state())

func _on_state_enter(state: SD_State) -> void:
	if not state:
		return
	
	if not is_instance_valid(_model):
		return
	
	var movement: AnimationNodeStateMachinePlayback = _model.get_tree_parameter("parameters/movement/playback") as AnimationNodeStateMachinePlayback
	
	match state.name:
		"ground":
			movement.travel("human_idle")
		"walk":
			pass
		"run":
			pass
		
	
	
