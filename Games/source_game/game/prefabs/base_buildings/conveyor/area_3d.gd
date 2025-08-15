extends Area3D

@export var conveyor_speed: float = 1.0
@export var conveyor_dir: Vector3 = Vector3(0, 0, -1)
@export var acceleration: float = 5.0
func _process(delta: float) -> void:
	var global_dir = transform.basis * conveyor_dir.normalized()
	var target_velocity = global_dir * conveyor_speed
	
	for body in get_overlapping_bodies():
		if body is RigidBody3D and not body.is_sleeping():
			body.linear_velocity = body.linear_velocity.lerp(
				target_velocity, 
				clamp(acceleration * delta, 0.0, 1.0)
			)
