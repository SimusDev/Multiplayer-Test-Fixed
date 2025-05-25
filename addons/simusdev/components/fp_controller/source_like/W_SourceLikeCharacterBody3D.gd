extends W_FPCSourceLike
class_name W_SourceLikeCharacterBody3D

@export var body: CharacterBody3D

@export_group("Stats")
@export var gravity: float = 980
@export var jump_force: float = 6.0
@export var move_acceleration: float = 16.0

@export var speed: float = 3.5
@export var speed_scale: float = 1.0

var _move_direction: Vector3 = Vector3.ZERO

func _enabled_status_changed() -> void:
	set_process(enabled)
	set_physics_process(enabled)

func _physics_process(delta: float) -> void:
	if body.is_on_floor():
		_handle_ground_physics(delta)
	else:
		_handle_air_physics(delta)
	
	body.move_and_slide()

func _handle_ground_physics(delta: float) -> void:
	var current_speed: float = speed * speed_scale
	
	var _direction: Vector3 = (body.transform.basis * _move_direction).normalized()
	var acceleration_speed: float = move_acceleration * delta
	if _direction:
		body.velocity.x = lerp(body.velocity.x, _direction.x * current_speed, acceleration_speed)
		body.velocity.z = lerp(body.velocity.z, _direction.z * current_speed, acceleration_speed)
	else:
		body.velocity.x = lerp(body.velocity.x, 0.0, acceleration_speed)
		body.velocity.z = lerp(body.velocity.z, 0.0, acceleration_speed)
	
	

func _handle_air_physics(delta: float) -> void:
	body.velocity.y -= (gravity) * (delta ** 2)

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
		body.velocity.y += jump_force
	
	
