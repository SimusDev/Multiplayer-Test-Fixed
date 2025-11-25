extends SD_NetTrunk
class_name SD_NetTrunkGame

var _caller: SD_NetFunctionCaller

func _initialized() -> void:
	_caller = SD_NetFunctionCaller.new()
	_caller.default_channel = "spawner"
	add_child(_caller)
	
	

func spawn_node(node: Node) -> void:
	if not SD_Network.is_server():
		return
	
	if node.scene_file_path.is_empty():
		return singleton.debug_print("cant spawn node %s, scene file path is empty!" % [str(node)], SD_ConsoleCategories.ERROR)
	
	if !node.is_inside_tree():
		return singleton.debug_print("cant spawn node %s, node must be in scene tree!" % [str(node)], SD_ConsoleCategories.ERROR)
	
	node.name = node.name.validate_node_name()
	
	_caller.call_func_except_self(_spawn, [str(node.get_parent().get_path()).replacen("/root/", ""), load(node.scene_file_path), node.name])

func _spawn(parent_path: String, prefab: PackedScene, node_name: String) -> void:
	if SD_Network.is_server():
		return
	
	var parent: Node = get_node("/root/" + parent_path)
	if not is_instance_valid(parent):
		singleton.debug_print("(%s): cant spawn scene(%s), node not found!" % [parent_path, prefab.resource_path, SD_ConsoleCategories.ERROR])
	

func despawn_node(node: Node) -> void:
	if not SD_Network.is_server():
		return
	
	if !node.is_inside_tree():
		return singleton.debug_print("cant spawn node %s, node must be in scene tree!" % [str(node)], SD_ConsoleCategories.ERROR)


func _despawn(node: Node) -> void:
	if SD_Network.is_server():
		return
	 
	
