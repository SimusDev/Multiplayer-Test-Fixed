extends Area3D

var conveyor_speed:float = 1.0
var conveyor_dir:Vector3 = Vector3(0, 0, -1)

func _process(delta: float) -> void:
	for body in get_overlapping_bodies():
		if body is RigidBody3D:
			body.linear_velocity = (conveyor_dir * conveyor_speed) * transform.origin.z
