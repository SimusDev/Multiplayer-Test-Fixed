extends Resource
class_name SD_DynamicNodeSpawnData

var data: SD_SavedNodeData

var _console: SD_TrunkConsole
var _console_debug: bool = true

var _name: String
var _scene: PackedScene
var _spawn_point_node: Node

var _instance: Node
var _parent_path: String = ""

func _init(_data: SD_SavedNodeData, debug: bool = false) -> void:
	_console = SimusDev.console
	_console_debug = debug
	data = _data
	
	_name = _data.node_name
	
	var exist_node: Node = SimusDev.get_node_or_null(data.id)
	if exist_node:
		if debug: _console.write_from_object(self, "can't load PackedScene(%s) by path, node already exists!: %s" % [data.scene_file_path, (exist_node.get_path())], SD_ConsoleCategories.CATEGORY.WARNING)
	else:
		_scene = load(data.scene_file_path) as PackedScene
		
		_parent_path = data.id.replacen(_name, "")
		_spawn_point_node = SimusDev.get_node_or_null(_parent_path)
		if not is_instance_valid(_spawn_point_node):
			if debug: _console.write_from_object(self, "can't find node by path '%s' (SpawnPoint): " % [_parent_path], SD_ConsoleCategories.CATEGORY.ERROR)
	
func create_instance() -> SD_DynamicNodeSpawnData:
	if _scene and _spawn_point_node:
		_instance = _scene.instantiate()
		if _console_debug: _console.write_from_object(self, "PackedScene was instantiate: %s (%s)" % [_scene.resource_path, get_node_name()], SD_ConsoleCategories.CATEGORY.INFO)
	
	return self

func spawn() -> SD_DynamicNodeSpawnData:
	var instance: Node = get_instance()
	if instance:
		if not instance.is_inside_tree():
			instance.name = get_node_name()
			get_spawn_point().add_child(instance)
			if _console_debug: _console.write_from_object(self, "node '%s' spawned under %s: " % [get_packed_scene().resource_path, get_spawn_point().get_path()], SD_ConsoleCategories.CATEGORY.INFO)
		else:
			if _console_debug: _console.write_from_object(self, "can't spawn '%s' because node is already exists under %s: " % [get_packed_scene().resource_path, get_spawn_point().get_path()], SD_ConsoleCategories.CATEGORY.WARNING)
			
		
	#if _console_debug: _console.write_from_object(self, "failed to spawn '%s' under %s: " % [data.scene_file_path, _parent_path], SD_ConsoleCategories.CATEGORY.ERROR)
	return self

func get_node_name() -> String:
	return _name

func get_packed_scene() -> PackedScene:
	return _scene

func get_instance() -> Node:
	if is_instance_valid(_instance):
		return _instance
	return null

func get_spawn_point() -> Node:
	return _spawn_point_node
