class_name CSharkBullet extends RigidBody3D

@export var bullet_properties:R_CSharkBulletProperties
@export var wall_bullet_scene:PackedScene

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	queue_free()
