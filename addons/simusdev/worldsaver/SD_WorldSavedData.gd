extends Resource
class_name SD_WorldSavedData

var _saver: SD_WorldSaver

@export var path: String = ""

@export var _nodes: Dictionary[String, SD_WorldSavedNodeData] = {}

@export var _storage: Dictionary[String, Variant]

func save_var(key: String, value: Variant) -> void:
	_storage[key] = value

func load_var(key: String, default_value: Variant = null) -> Variant:
	return _storage.get(key, default_value)

func create_or_get_data_from_node(node: Node) -> SD_WorldSavedNodeData:
	if (not node) or (not node.is_inside_tree()):
		return
	
	var data: SD_WorldSavedNodeData
	var node_path: String = node.get_path()
	
	if _nodes.has(node_path):
		return _nodes.get(node_path) as SD_WorldSavedNodeData
	
	data = SD_WorldSavedNodeData.new()
	var initialized: bool = data.initialize(node)
	if initialized:
		_nodes[node_path] = data
	
	return data

func get_data_from_node(node: Node) -> SD_WorldSavedNodeData:
	var node_path: String = node.get_path()
	if _nodes.has(node_path):
		return _nodes.get(node_path) as SD_WorldSavedNodeData
	return null

func delete_node_data(data: SD_WorldSavedNodeData) -> void:
	var founded_key = _nodes.find_key(data)
	if founded_key != null:
		_nodes.erase(founded_key)

func change_data_node_path(data: SD_WorldSavedNodeData, new_path: String) -> void:
	var old_path = _nodes.find_key(data)
	if old_path != null:
		_nodes.erase(old_path)
		_nodes[new_path] = data

func get_saved_nodes() -> Dictionary[String, SD_WorldSavedNodeData]:
	return _nodes

func get_data_node_path(data: SD_WorldSavedNodeData) -> String:
	var founded_path = _nodes.find_key(data)
	if founded_path != null:
		return founded_path
	return ""
