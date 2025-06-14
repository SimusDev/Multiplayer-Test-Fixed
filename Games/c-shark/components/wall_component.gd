extends Area3D
class_name CSharkWallComponent



func _on_body_entered(body: Node3D) -> void:
	if body is CSharkBullet:
		
		var global_pos = body.global_position
		
		var bullet_wall = body.wall_bullet_scene.instantiate()
		
		add_child(bullet_wall)
		bullet_wall.rotation = get_parent().rotation
		bullet_wall.global_position = global_pos
