extends SD_NetworkSpawner
class_name SourceNetworkSpawner


func can_serialize(node: Node) -> bool:
	return super(node)

func _serialize_custom(node: Node, data: Dictionary) -> void:
	var object: R_SourceWorldObject = R_SourceWorldObject.find_in(node)
	if object:
		data.so = object.id

func _deserialize_custom(node: Node, data: Dictionary) -> void:
	var object: R_SourceWorldObject = R_SourceWorldObject.get_by_id(data.get("so", ""))
	if object:
		object.set_in(node)
	

func spawn(data: Dictionary) -> void:
	if SD_Network.is_server():
		return
	
	var node_name: String = data.n
	var root: Node = get_node(data.p)
	if not is_instance_valid(root):
		return
	var deferred_spawn_array: Array = _deferred_spawns.get_or_add(root, [])
	
	if node_name in deferred_spawn_array:
		return
	
	var deserialized: Dictionary = deserialize(data)
	var node: Node = deserialized.node
	var new_data: Dictionary = deserialized.data
	
	debug_print("spawning... %s" % [str(deserialized.node)], SD_ConsoleCategories.INFO)
	
	deferred_spawn_array.append(node_name)
	
	root.add_child.call_deferred(node)
	node.tree_entered.connect(
		func():
			deferred_spawn_array.erase(node_name)
			spawned.emit(node, new_data)
	)
	
