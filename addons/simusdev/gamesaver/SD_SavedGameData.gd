extends Resource
class_name SD_SavedGameData

@export var _nodes: Dictionary[String, SD_SavedNodeData] = {}

@export var _storage := {}

func write_saveable(saveable: W_SaveableNode) -> SD_SavedNodeData:
	var node_data = SD_SavedNodeData.new()
	node_data.initialize(saveable, self)
	
	var id: String = node_data.id
	
	_nodes[id] = node_data
	return _nodes[id]

func delete_saveable(saveable: W_SaveableNode) -> void:
	var node_data: SD_SavedNodeData = saveable.get_node_data()
	if node_data:
		_nodes.erase(node_data.id)
	

func get_saveable(saveable: W_SaveableNode) -> SD_SavedNodeData:
	var id: String = saveable.node.get_path()
	
	var saved_data: SD_SavedNodeData = saveable.get_node_data()
	if saved_data:
		id = saved_data.id
	
	var _saved_data_from_dict: SD_SavedNodeData = _nodes.get(id, null) as SD_SavedNodeData
	return _saved_data_from_dict
	

func get_saved_nodes_dictionary() -> Dictionary:
	return _nodes

func get_saved_nodes() -> Array[SD_SavedNodeData]:
	return _nodes.values()

func set_value(key: String, value: Variant) -> void:
	_storage[key] = value

func erase_value(key: String) -> void:
	_storage.erase(key)

func get_value(key: String, default_value = null) -> Variant:
	return _storage.get(key, default_value)
