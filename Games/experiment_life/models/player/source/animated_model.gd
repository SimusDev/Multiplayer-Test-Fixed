@tool
extends W_AnimatedModel3D

@export var _movement: W_FPCSourceLikeMovement

@onready var _actor: CharacterBody3D = _movement.actor
@onready var _movement_playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_movement_playback = get_tree_parameter("parameters/movement_sm/playback")
	
	#_movement.state_machine.transitioned.connect(_on_state_machine_transitioned)
	_movement.state_machine.state_enter.connect(update_from_state)
	update_from_state(_movement.state_machine.get_current_state())

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	var actor_velocity: Vector3 = _actor.velocity * _actor.transform.basis
	
	var blend_position: Vector2 = Vector2(actor_velocity.x, -actor_velocity.z)
	set_tree_parameter("parameters/movement_sm/movement/blend_position", blend_position)
	
	set_tree_parameter("parameters/movement_sm/crouch/blend_position", blend_position)
	
	set_tree_parameter("parameters/movement_tscale/scale", actor_velocity.length() / 6.0)

func update_from_state(state: SD_State) -> void:
	#print(state)
	if not state:
		return
	
	match state.name:
		"ground":
			_movement_playback.start("idle")
		"walk":
			_movement_playback.start("movement")
		"run":
			_movement_playback.start("movement")
		"crouched":
			_movement_playback.start("crouch")
		"crouched_walk":
			_movement_playback.start("crouch")
		"crouched_run":
			_movement_playback.start("crouch")
		"jump":
			var request: String = "parameters/jumpBlendTree/OneShot/request"
			set_tree_parameter(request, AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			
			

func _on_state_machine_transitioned(from: SD_State, to: SD_State) -> void:
	update_from_state(to)
