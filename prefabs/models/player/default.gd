extends Node3D

@export var disabled_at_start: bool = false

@export var camera: W_FPCSourceLikeCamera 
@export var movement: W_FPCSourceLikeMovement

@export var tree: AnimationTree

var actor: CharacterBody3D

@export var _body_rot: Node3D
@export var _head_rot: Node3D

@onready var sm_playback: AnimationNodeStateMachinePlayback = tree.get("parameters/StateMachine/playback")

@export var _glasses_model: Node3D

@export var velocity_interpolation_speed: float = 15.0
var _interpolated_velocity: Vector3 = Vector3.ZERO

signal legs_footstep()

func do_footstep() -> void:
	legs_footstep.emit()
	
func _ready() -> void:
	if disabled_at_start:
		set_process(false)
		set_physics_process(false)
		return
	
	actor = movement.actor
	
	_interpolated_velocity = actor.velocity
	
	if is_multiplayer_authority():
		movement.state_machine.transitioned.connect(_on_movement_state_machine_transitioned)
		hide()
		return
	
	tree.active = true
	
	
	

func _on_movement_state_machine_transitioned(from: SD_State, to: SD_State) -> void:
	if to.name == "jump":
		sm_playback.start("jump")

func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	_interpolated_velocity = lerp(_interpolated_velocity, actor.velocity, velocity_interpolation_speed * delta)
	tree.set("parameters/walk_blend/blend_position", _interpolated_velocity)
	_body_rot.rotation_degrees.x = camera.rotation_degrees.x * 0.25
	_head_rot.rotation_degrees.x = camera.rotation_degrees.x * 0.4

func get_glasses_model() -> Node3D:
	return _glasses_model
