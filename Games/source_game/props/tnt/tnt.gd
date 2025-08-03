extends RigidBody3D

@export var damage: float = 100.0
@export var size: float = 1.0

func _on_source_health_died() -> void:
	if SD_Network.is_server():
		var explosion := SourceExplosion.create_at(self)
		explosion.set_damage(damage).set_size(size)
		explosion.explode()
		queue_free()
