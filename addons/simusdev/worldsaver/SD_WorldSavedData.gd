extends Resource
class_name SD_WorldSavedData

var _saver: SD_WorldSaver

var _nodes: Dictionary[String, SD_WorldSavedNodeData] = {}

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
	var founded_key: String = _nodes.find_key(data)
	if founded_key != null:
		_nodes.erase(founded_key)

func get_saved_nodes() -> Dictionary[String, SD_WorldSavedNodeData]:
	return _nodes
