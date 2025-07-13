class_name SourceWeaponBullet extends RigidBody3D

@export var bullet_resource:R_SourceBullet
@export var bullet_model:PackedScene

@export var life_time:float = 10.0 #seconds

func _ready() -> void:
	self.set_collision_layer_value(1, false)
	if bullet_model:
		var bullet_instance = bullet_model.instantiate()
		add_child(bullet_instance)

		if bullet_instance is MeshInstance3D:
			bullet_instance.create_convex_collision()
			var static_body:StaticBody3D
			for child in bullet_instance.get_children():
				if child is StaticBody3D:
					static_body = child
			var shape = static_body.get_node("CollisionShape3D") as CollisionShape3D
			shape.reparent(self)
			static_body.queue_free()
	
	await get_tree().create_timer(life_time).timeout
	queue_free()

func _process(delta: float) -> void:
	pass
