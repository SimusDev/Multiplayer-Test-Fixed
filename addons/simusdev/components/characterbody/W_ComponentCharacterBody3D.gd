@icon("res://addons/simusdev/icons/CharacterBody3D.svg")
extends Node
class_name W_ComponentCharacterBody3D

@export var body: CharacterBody3D

@export var enabled: bool = true

@export_group("Stats")
@export var stats_multiplier: float = 1.0
@export var gravity: float = 980
@export var jump_force: float = 6.0
@export var move_acceleration: float = 16.0

@export var move_speed: float = 3.5
@export var sprint_speed: float = 6.0
@export var crouch_speed: float = 1.5
@export var crouch_sprint_speed: float = 1.8

@export var is_sprinting: bool = false : set = set_sprinting 
@export var is_crouching: bool = false : set = set_crouching 

@export_group("Interpolation")

var _move_direction: Vector3 = Vector3.ZERO

signal on_sprinting(status: bool)
signal on_crouching(status: bool)

func set_sprinting(value: bool) -> void:
	if is_sprinting != value:
		is_sprinting = value
		on_sprinting.emit(value)

func set_crouching(value: bool) -> void:
	if is_crouching != value:
		is_crouching = value
		on_crouching.emit(value)

func _physics_process(delta: float) -> void: 
	if !enabled:
		return
	
	_body_physics_process(delta)

func _body_physics_process(delta: float) -> void:
	body.velocity.y -= (gravity * stats_multiplier) * (delta ** 2)
	
	var current_speed: float = move_speed * stats_multiplier
	if is_sprinting:
		current_speed = sprint_speed * stats_multiplier
	if is_crouching:
		current_speed = crouch_speed * stats_multiplier
	if is_crouching and is_sprinting:
		current_speed = crouch_sprint_speed * stats_multiplier
	
	
	var _direction: Vector3 = (body.transform.basis * _move_direction).normalized()
	var acceleration_speed: float = move_acceleration * delta
	if _direction:
		body.velocity.x = lerp(body.velocity.x, _direction.x * current_speed, acceleration_speed)
		body.velocity.z = lerp(body.velocity.z, _direction.z * current_speed, acceleration_speed)
	else:
		body.velocity.x = lerp(body.velocity.x, 0.0, acceleration_speed)
		body.velocity.z = lerp(body.velocity.z, 0.0, acceleration_speed)
	
	body.move_and_slide()

func set_move_direction(direction: Vector3) -> void:
	_move_direction = direction

func get_move_direction() -> Vector3:
	return _move_direction

func get_velocity() -> Vector3:
	return body.velocity

func is_on_floor() -> bool:
	return body.is_on_floor()

func jump(force: float = jump_force) -> void:
	if body.is_on_floor():
		body.velocity.y += jump_force * stats_multiplier
	
	
