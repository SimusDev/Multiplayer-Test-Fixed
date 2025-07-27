extends SD_NetTrunk
class_name SD_NetTrunkCache

var _local_changes: Array[Dictionary] = []

func _initialized() -> void:
	#return #cache disabled, many bugs :(((
	
	return
	
	if singleton.settings.cache_all_nodes_in_scene_tree:
		get_tree().node_added.connect(_on_scene_tree_node_added)

func get_cached_nodes_by_id() -> Dictionary[int, NodePath]:
	return SD_Network.cache_get().get_or_add("cn_id", {} as Dictionary[int, NodePath]) as Dictionary[int, NodePath]

func get_cached_nodes_by_path() -> Dictionary[NodePath, int]:
	return SD_Network.cache_get().get_or_add("cn_path", {} as Dictionary[NodePath, int]) as Dictionary[NodePath, int]

func get_cached_path_by_id(id: int) -> NodePath:
	return get_cached_nodes_by_id().get(id)

func get_cached_id_by_path(path: NodePath) -> int:
	return get_cached_nodes_by_path().get(path)

func try_cache_node(node: Node) -> void:
	return
	
	if not is_instance_valid(node):
		return
	
	if not SD_Network.is_server():
		return
	
	var cache_by_path: Dictionary[NodePath, int] = get_cached_nodes_by_path()
	var cache_by_id: Dictionary[int, NodePath] = get_cached_nodes_by_id()
	var path: NodePath = node.get_path()
	if cache_by_path.has(path):
		return
	
	var net_id: int = node.get_instance_id()
	
	cache_by_path[path] = net_id
	cache_by_id[net_id] = path
	
	node.tree_exited.connect(_on_cached_node_tree_exited.bind(node, path))
	
	var local_change: Dictionary[String, Variant] = {}
	local_change.net_id = net_id
	local_change.path = path
	local_change.status = true
	
	_local_changes.append(local_change)
	
	debug_print("node cached: %s [%s]" % [str(path), str(net_id)], SD_ConsoleCategories.CATEGORY.INFO)

func try_uncache_node(node: Node) -> void:
	if not is_instance_valid(node):
		return
	
	if not SD_Network.is_server():
		return
	
	var cache_by_path: Dictionary[NodePath, int] = get_cached_nodes_by_path()
	var cache_by_id: Dictionary[int, NodePath] = get_cached_nodes_by_id()
	var net_id: int = cache_by_path.get(node.get_path())
	if net_id < 0:
		return
	
	var path: NodePath = cache_by_id.get(net_id) as NodePath
	cache_by_id.erase(net_id)
	cache_by_path.erase(path)
	
	var local_change: Dictionary[String, Variant] = {}
	local_change.net_id = net_id
	local_change.path = path
	local_change.status = false
	
	_local_changes.append(local_change)
	
	debug_print("node removed from cache: %s [%s]" % [str(path), str(net_id)], SD_ConsoleCategories.CATEGORY.INFO)

func _on_scene_tree_node_added(node: Node) -> void:
	try_cache_node(node)

func _on_cached_node_tree_exited(node: Node, path: NodePath) -> void:
	try_uncache_node(node)

func _process(delta: float) -> void:
	if !SD_Network.is_server():
		return
	
	for change in _local_changes:
		if change.status:
			_client_cache.rpc(change.net_id, change.path)
		else:
			_client_uncache.rpc(change.net_id, change.path)
		
		_local_changes.erase(change)

@rpc("any_peer", "reliable", "call_local")
func _client_cache(net_id: int, path: NodePath) -> void:
	if SD_Network.is_server():
		return
	
	get_cached_nodes_by_id()[net_id] = path
	get_cached_nodes_by_path()[path] = net_id
	

@rpc("any_peer", "reliable", "call_local")
func _client_uncache(net_id: int, path: NodePath) -> void:
	if SD_Network.is_server():
		return
	
	get_cached_nodes_by_id().erase(net_id)
	get_cached_nodes_by_path().erase(path)

func debug_print(text, category: int = 0) -> void:
	if singleton.settings.debug_cache:
		singleton.debug_print(text, category)
