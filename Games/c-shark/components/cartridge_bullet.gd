class_name CSharkCartridgeBullet extends RigidBody3D

func _ready() -> void:
	linear_velocity = Vector3(1, 2, 0)

	await get_tree().create_timer(5).timeout
	queue_free()
