@icon("res://addons/simusdev/icons/Save.png")
extends Node
class_name SD_SceneSaverInstance

@export var replicate: bool = false
@export var root: Node
@export var channel: StringName

enum LOAD {
	READY_OR_WHEN_LOAD,
	READY,
	WHEN_LOAD,
	NEVER,
}

@export var load: LOAD = LOAD.READY_OR_WHEN_LOAD
@export var properties: Dictionary[NodePath, PackedStringArray] = {}

var _saver: SD_SceneSaverLoader

var _data: SD_SceneSavedNode
var _saved: SD_SceneSavedData
var _last_path: NodePath

static func find_above(node: Node) -> SD_SceneSaverInstance:
	return SD_Components.node_find_above_by_script(node, SD_SceneSaverInstance) as SD_SceneSaverInstance

func _enter_tree() -> void:
	if not root:
		root = get_parent()
	
	SD_Components.append_to(root, self)
	
	for i in SD_SceneSaverLoader.get_instances():
		if i.channel == channel:
			_saver = i
			i.begin_save.connect(_on_save_begin_)
			i.loaded.connect(_on_loaded_)
	
	if not _saver:
		SimusDev.console.write_from_object(self, "no one scene saver loader instance was found.", SD_ConsoleCategories.ERROR)
		return
	
	if !_last_path.is_empty():
		if root.get_path() != _last_path:
			_saver.move_node_to(_last_path, root.get_path())
	
	_last_path = root.get_path()
	_data = _saver.get_or_create_node(_last_path)

func _ready() -> void:
	if load == LOAD.READY_OR_WHEN_LOAD or load == LOAD.READY:
		_on_loaded_()

func _get_registered_properties(node: Node) -> PackedStringArray:
	var path: NodePath = get_path_to(node)
	if properties.has(path):
		return properties.get(path) as PackedStringArray
	
	var p := PackedStringArray()
	properties.set(path, p)
	return p

func register_properties(node: Node, properties: PackedStringArray) -> void:
	if not is_inside_tree():
		await tree_entered
	
	var array: PackedStringArray = _get_registered_properties(node)
	array.append_array(properties)

func register_property(node: Node, property: String) -> void:
	register_properties(node, [property])

func _on_save_begin_() -> void:
	_data = _saver.get_or_create_node(_last_path)
	try_save_data()

func _on_loaded_() -> void:
	if load == LOAD.READY:
		return
	
	_data = _saver.get_or_create_node(_last_path)
	try_load_data()

func try_load_data() -> void:
	for path in properties:
		var node: Node = get_node_or_null(path)
		var list: PackedStringArray = properties[path]
		for p in list:
			var value: Variant = read_node_property(node, p, node.get(p))
			node.set(p, value)

func try_save_data() -> void:
	if not root.scene_file_path.is_empty() and replicate:
		_data.scene = load(root.scene_file_path)
	
	for path in properties:
		var node: Node = get_node_or_null(path)
		var list: PackedStringArray = properties[path]
		for p in list:
			write_node_property(node, p, node.get(p))
		

func write_property(property: String, value: Variant) -> void:
	_data.properties.set(property, value)

func read_property(property: String, default_value: Variant = null) -> Variant:
	return _data.properties.get(property, default_value)

func write_node_property(node: Node, property: String, value: Variant) -> void:
	var path: NodePath = get_path_to(node)
	(_data.node_properties.get_or_add(path, {} as Dictionary) as Dictionary).set(property, value)

func read_node_property(node: Node, property: String, default_value: Variant = null) -> Variant:
	var path: NodePath = get_path_to(node)
	return (_data.node_properties.get_or_add(path, {} as Dictionary) as Dictionary).get(property, default_value)
