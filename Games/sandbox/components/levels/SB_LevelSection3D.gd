extends Node3D
class_name SB_LevelSection3D

var _level: SB_Level3D

static func find_above(node: Node) -> SB_LevelSection3D:
	if node is SB_LevelSection3D:
		return node
	
	if node == SimusDev.get_tree().root:
		return null
	
	return find_above(node.get_parent())

func spawn_local(object: SB_WorldObject, instantiate: bool = true, settings: SB_LevelSpawnSettings = null) -> SBR_ObjectInstance:
	if not object:
		SimusDev.console.write_error("[%s] cant spawn null object")
		return
	
	var scene: PackedScene = object.prefab
	if not scene:
		SimusDev.console.write_error("[%s] cant spawn object, prefab is empty: %s" % [name, object.resource_path])
		return
	
	
	var obj_instance := SBR_ObjectInstance.new()
	obj_instance.settings = settings
	obj_instance._parent = self
	obj_instance._spawner = _level.get_spawner()
	obj_instance._object = object
	
	var instance: Node = scene.instantiate()
	object.set_in(instance)
	
	obj_instance._source = instance
	obj_instance._initialize()
	
	if instantiate:
		obj_instance.instantiate()
	
	return obj_instance

func despawn_local(node: Node, settings: SB_LevelSpawnSettings = null) -> void:
	node.queue_free()
	
	if settings:
		if settings.handle_spawner:
			_level.get_spawner().server_update_remove(node, node.get_parent())

func spawn_request(object: SB_WorldObject, instantiate: bool = true, settings: SB_LevelSpawnSettings = null) -> void:
	SimusDev.console.write_info("[%s, %s, %s] spawn requested: %s" % [_level.name, name, object.id])
	SD_Multiplayer.sync_call_function_on_server(self, spawn_local, [object, instantiate, settings])
	
