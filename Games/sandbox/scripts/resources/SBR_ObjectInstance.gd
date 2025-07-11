extends Resource
class_name SBR_ObjectInstance

var _object: SB_WorldObject

var _source: Node
var _parent: Node

var settings: SB_LevelSpawnSettings

var _spawner: SD_MPClientNodeSpawner

func get_object() -> SB_WorldObject:
	return _object

func get_source() -> Node:
	return _source

func instantiate() -> Node:
	if _source.is_inside_tree():
		return _source
	
	if settings:
		if _source is Node3D:
			_source.position = settings.position
	
	_parent.add_child(_source)
	
	if settings.handle_spawner:
		_spawner.server_update_add(_source, _parent)
	
	return _source
