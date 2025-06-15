class_name CSharkCartridgeBullet extends RigidBody3D

func _ready() -> void:
	angular_velocity.y = randf_range(25, 50)
	angular_velocity.x = randf_range(25, 50)

	await get_tree().create_timer(5).timeout
	queue_free()
