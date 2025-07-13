class_name SourceBulletShell extends RigidBody3D

@export var model:PackedScene
var life_time:float = 15.0

func _ready() -> void:
	self.set_collision_layer_value(1, false)
	if model:
		var shell = model.instantiate()
		add_child(shell)

		if shell is MeshInstance3D:
			shell.create_convex_collision()
			var static_body:StaticBody3D
			for child in shell.get_children():
				if child is StaticBody3D:
					static_body = child
			static_body.get_node("CollisionShape3D").reparent(self)
			static_body.queue_free()

	await get_tree().create_timer(life_time).timeout
	queue_free()
