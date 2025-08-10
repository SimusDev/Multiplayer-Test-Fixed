extends SRC_S_Singleton
class_name SRC_S_Deaths

func _ready() -> void:
	S_EventDeath.as_event().published.connect(_on_death.bind(S_EventDeath.as_event()))

func _on_death(event: S_EventDeath) -> void:
	if not SD_Network.is_server():
		return
	
	var object: R_SourceWorldObject = R_SourceWorldObject.find_in(event.source)
	
	if !object:
		return
	
	if object is R_SourceEntity:
		if object.ragdoll:
			var ragdoll: C_SourceWorldObjectReference = object.ragdoll.create().instantiate()
			ragdoll.set_global_transform_from(event.source)
		
		if object.death_sound:
			object.death_sound.try_play_server(event.source)
			
	if object.is_destroyable():
		event.source.queue_free()
	
	#SimusDev.console.write_events("target died: %s" % [str(event.source)])
