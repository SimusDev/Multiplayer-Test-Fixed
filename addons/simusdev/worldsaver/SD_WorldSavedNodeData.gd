extends Resource
class_name SD_WorldSavedNodeData

@export var _properties: Dictionary[String, Variant] = {}

@export var is_scene: bool = false
@export var instance_data: String

func initialize(node: Node) -> bool:
	if not node.is_inside_tree():
		return false
	
	node.name = node.name.validate_node_name()
	
	return true

func load_property(property: String, default_value: Variant = null) -> Variant:
	return _properties.get(property, default_value)

func save_property(property: String, value: Variant) -> void:
	_properties.set(property, value)

func can_instantiate() -> bool:
	return not instance_data.is_empty()

func serialize_instance(from_node: Node) -> void:
	if from_node.scene_file_path.is_empty():
		is_scene = false
		instance_data = var_to_str(from_node)
		return
	
	is_scene = true
	instance_data = from_node.scene_file_path

func deserialize_instance() -> Node:
	var instance: Node = null
	
	if is_scene:
		var scene: PackedScene = load(instance_data) as PackedScene
		instance = scene.instantiate()
	else:
		instance = str_to_var(instance_data)
	
	return instance
