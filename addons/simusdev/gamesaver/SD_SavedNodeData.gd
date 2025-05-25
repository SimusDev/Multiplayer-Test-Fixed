extends Resource
class_name SD_SavedNodeData

@export var id: String
@export var saveable_path: String

@export var node_name: String

@export var scene_file_path: String

@export var data := {}

var _gamedata: SD_SavedGameData

func initialize(saveable: W_SaveableNode, gamedata: SD_SavedGameData) -> void:
	_gamedata = gamedata
	update_paths(saveable)

func update_paths(saveable: W_SaveableNode) -> void:
	
	if not saveable.is_inside_tree():
		return
	
	id = saveable.node.get_path()
	saveable_path = saveable.get_path()
	
	node_name = saveable.node.name
	
	scene_file_path = saveable.node.scene_file_path

func deinitialize() -> void:
	if !_gamedata:
		_gamedata = SimusDev.gamesaver.current_save
	
	if _gamedata:
		_gamedata._nodes.erase(id)

func get_gamedata() -> SD_SavedGameData:
	return _gamedata

func save_variable(var_name: String, value: Variant) -> void:
	data[var_name] = value

func load_variable(var_name: String, default_value = null) -> Variant:
	var loaded: Variant = data.get(var_name, default_value)
	return loaded

func try_get_node_in_scene_tree() -> Node:
	return SimusDev.get_node_or_null(id)

func try_get_saveable_in_scene_tree() -> W_SaveableNode:
	return SimusDev.get_node_or_null(saveable_path) as W_SaveableNode
