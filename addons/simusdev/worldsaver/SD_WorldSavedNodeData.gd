extends Resource
class_name SD_WorldSavedNodeData

@export var _properties: Dictionary[String, Variant] = {}

@export var serialize_type: int = 0
@export var packed_data: PackedScene
@export var instance_data: String
@export var scene_path: String
@export var index: int = -1

@export var init_path: String

enum SERIALIZE_TYPE {
	PACKED_SCENE_OR_TO_STRING,
	PACK,
}

@export var _storage: Dictionary[String, Variant]

func save_var(key: String, value: Variant) -> void:
	_storage[key] = value

func load_var(key: String, default_value: Variant = null) -> Variant:
	return _storage.get(key, default_value)

func initialize(node: Node) -> bool:
	if not node.is_inside_tree():
		return false
	
	node.name = node.name.validate_node_name()
	
	return true

func load_property(property: String, default_value: Variant = null) -> Variant:
	return _properties.get(property, default_value)

func save_property(property: String, value: Variant) -> void:
	_properties.set(property, value)

func has_property(property: String) -> bool:
	return _properties.has(property)

func can_instantiate() -> bool:
	if packed_data or (not scene_path.is_empty()):
		return true
	return instance_data.is_empty() == false

func serialize_instance(from_node: Node, type: SERIALIZE_TYPE) -> void:
	serialize_type = type
	index = from_node.get_index()
	
	match serialize_type:
		SERIALIZE_TYPE.PACK:
			var packed_scene: PackedScene = PackedScene.new()
			packed_scene.pack(from_node)
			packed_data = packed_scene
		SERIALIZE_TYPE.PACKED_SCENE_OR_TO_STRING:
			if from_node.scene_file_path.is_empty():
				var data: String = var_to_str(from_node)
				instance_data = data
			else:
				scene_path = from_node.scene_file_path

func deserialize_instance() -> Node:
	var node: Node = null
	match serialize_type:
		SERIALIZE_TYPE.PACK:
			if packed_data and packed_data.can_instantiate():
				node = packed_data.instantiate()
		SERIALIZE_TYPE.PACKED_SCENE_OR_TO_STRING:
			if instance_data.is_empty():
				var scene: PackedScene = load(scene_path)
				node = scene.instantiate()
			else:
				node = str_to_var(instance_data)
	return node
