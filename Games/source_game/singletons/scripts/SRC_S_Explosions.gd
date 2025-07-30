extends SRC_S_Singleton
class_name SRC_S_Explosions

func _ready() -> void:
	var event: S_EventExplosionAfter = S_EventExplosionAfter.get_by_script(S_EventExplosionAfter) as S_EventExplosionAfter
	event.published.connect(_on_explosion_event.bind(event))

func _on_explosion_event(event: S_EventExplosionAfter) -> void:
	SD_Network.call_func(create_particles, [event.explosion.size, event.explosion.global_position])

func create_particles(size: int, position: Vector3) -> void:
	if SD_Network.is_dedicated_server():
		return
	
	var particle_obj: C_SourceWorldObjectReference = R_SourceWorldObject.get_by_id("world.explosion_particle").create()
	var particle: Node3D = particle_obj.source
	
	particle.size = size
	particle_obj.instantiate_local()
	particle.global_position = position
	var event: S_EventExplosionParticlesCreated = S_EventExplosionParticlesCreated.get_by_script(S_EventExplosionParticlesCreated)
	event.particles = particle
	event.publish()
	
