extends Node3D
class_name SB_LevelSection3D

func spawn_local(object: SB_WorldObject, instantiate: bool = true, settings: SB_LevelSpawnSettings = null) -> Node:
	if not object:
		SimusDev.console.write_error("[%s] cant spawn null object")
		return
	
	var scene: PackedScene = object.prefab
	if not scene:
		SimusDev.console.write_error("[%s] cant spawn object, prefab is empty: %s" % [name, object.resource_path])
		return
	
	
	var instance: Node = scene.instantiate()
	if instantiate:
		add_child(instance)
	
	if settings:
		if instance is Node3D:
			instance.global_position = settings.global_position
	
	return instance

func despawn_local(node: Node) -> void:
	node.queue_free()
