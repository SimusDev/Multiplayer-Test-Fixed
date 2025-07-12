extends Resource
class_name SBR_ObjectInstance

var _object: SB_WorldObject

var _source: Node
var _parent: Node

var settings: SB_LevelSpawnSettings

var _spawner: SD_MPClientNodeSpawner

var _level_section: SB_LevelSection3D

func get_level_section() -> SB_LevelSection3D:
	return _level_section

static func find_in(node: Node) -> SBR_ObjectInstance:
	if node.has_meta("SBR_ObjectInstance"):
		return node.get_meta("SBR_ObjectInstance")
	return null

func set_in(node: Node) -> void:
	node.set_meta("SBR_ObjectInstance", self)

func get_object() -> SB_WorldObject:
	return _object

func get_source() -> Node:
	return _source

func _initialize() -> void:
	_level_section = SB_LevelSection3D.find_above(_parent)
	set_in(_source)

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
