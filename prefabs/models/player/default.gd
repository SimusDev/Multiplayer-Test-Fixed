extends Node3D
class_name M_TestModel

@export var disabled_at_start: bool = false

@export var camera: W_FPCSourceLikeCamera 
@export var movement: W_FPCSourceLikeMovement

@export var tree: AnimationTree

@export var _body_rot: Node3D
@export var _head_rot: Node3D

@onready var sm_playback: AnimationNodeStateMachinePlayback = tree.get("parameters/StateMachine/playback")

@export var _glasses_model: Node3D

@export var velocity_interpolation_speed: float = 15.0

@export var BLEND_SPACE1D_ANIMATIONS: Dictionary[String, String] = {}

var _interpolated_velocity: Vector3 = Vector3.ZERO

signal legs_footstep()

var _velocity: Vector3 = Vector3.ZERO

func do_footstep() -> void:
	legs_footstep.emit()
	
func _ready() -> void:
	if disabled_at_start:
		set_process(false)
		set_physics_process(false)
		return
	
	movement.state_machine.transitioned.connect(_on_movement_state_machine_transitioned)
	
	tree.active = true
	
	$HideNodesWhenAuthority.hide_nodes()

func mix_set_animation_blend_position(blend1d_animation: String, value: float) -> void:
	if BLEND_SPACE1D_ANIMATIONS.has(blend1d_animation):
		var param_name: String = BLEND_SPACE1D_ANIMATIONS[blend1d_animation]
		tree.set(param_name, value)

func mix_get_animation_blend_position(blend1d_animation: String) -> float:
	if BLEND_SPACE1D_ANIMATIONS.has(blend1d_animation):
		var param_name: String = BLEND_SPACE1D_ANIMATIONS[blend1d_animation]
		return tree.get(param_name)
	return 0.0

func set_velocity(value: Vector3) -> void:
	_velocity = value

func get_velocity() -> Vector3:
	return _velocity

func _on_movement_state_machine_transitioned(from: SD_State, to: SD_State) -> void:
	if to.name == "jump":
		sm_playback.start("jump")

func _process(delta: float) -> void:
	_interpolated_velocity = lerp(_interpolated_velocity, _velocity, velocity_interpolation_speed * delta)
	var vec2: Vector2 = Vector2(_interpolated_velocity.x, _interpolated_velocity.z)
	tree.set("parameters/walk_blend/blend_position", vec2)
	
	if not is_multiplayer_authority():
		_body_rot.rotation_degrees.x = camera.rotation_degrees.x * 0.25
		_head_rot.rotation_degrees.x = camera.rotation_degrees.x * 0.4

func get_glasses_model() -> Node3D:
	return _glasses_model
