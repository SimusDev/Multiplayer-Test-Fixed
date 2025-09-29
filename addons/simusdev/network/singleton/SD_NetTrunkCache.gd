extends SD_NetTrunk
class_name SD_NetTrunkCache

enum TYPE {
	RESOURCE,
	METHOD,
	NODE,
}

const CHANNELS: Dictionary[int, int] = {
	TYPE.RESOURCE: 100,
	TYPE.METHOD : 101,
	TYPE.NODE : 102,
	
}

var _cached_input_map_string: Dictionary[StringName, int] = {}
var _cached_input_map_id: Dictionary[int, StringName] = {}

func _initialized() -> void:
	singleton.on_active_status_changed.connect(_on_active_status_changed)
	
	_cache_game_input()

func _cache_game_input() -> void:
	var action_id: int = 0
	for action in InputMap.get_actions():
		_cached_input_map_id[action_id] = action
		_cached_input_map_string[action] = action_id
		action_id += 1

func get_cached_input_map_action(id: int) -> Dictionary:
	return _cached_input_map_id.get(id)

func get_cached_input_map_id(action: StringName) -> Dictionary:
	return _cached_input_map_string.get(action)

func serialize_input_map(action: StringName) -> int:
	return _cached_input_map_string.get(action)

func deserialize_input_map(id: int) -> StringName:
	return _cached_input_map_id.get(id)

func cache_resource(resource: Resource) -> void:
	var path: String = resource.resource_path
	if path.is_empty():
		debug_print("cant cache resource without path: %s" % str(resource), SD_ConsoleCategories.ERROR)
		return
	
	var cache: PackedStringArray = SD_Network.get_cached_resources()
	if cache.has(path):
		return
	
	
	_cache_resource_rpc.rpc(path)

@rpc("call_local", "any_peer", "reliable", CHANNELS[TYPE.RESOURCE])
func _cache_resource_rpc(path: String) -> void:
	SD_Network.get_cached_resources().append(path)
	debug_print("resource cached: %s" % path)

func serialize_resource(resource: Resource) -> Variant:
	if resource.resource_path.is_empty() or resource.resource_local_to_scene:
		var array: Array = []
		array.append(var_to_str(resource))
		return array
	var id: int = get_cached_resources().find(resource.resource_path)
	if id > -1:
		return get_cached_resources().get(id)
	return resource.resource_path

func deserialize_resource(resource: Variant) -> Variant:
	if resource is int:
		return load(get_cached_resources().get(resource))
	elif resource is String:
		return load(resource)
	var arg: String = resource[0]
	return str_to_var(arg)

func get_cached_resources() -> PackedStringArray:
	return SD_Network.get_cached_resources()

func get_cached_methods() -> PackedStringArray:
	var cache := singleton.cache_get()
	if cache.has("m"):
		return cache["m"]
	var methods: PackedStringArray = PackedStringArray()
	cache.set("m", methods)
	return methods

func cache_method(method: Callable) -> void:
	var methods: PackedStringArray = get_cached_methods()
	var m_name: String = method.get_method()
	if methods.has(m_name):
		return
	
	methods.append(m_name)
	
	debug_print("method cached: %s" % m_name)
	
	_cache_method_rpc.rpc(m_name)

@rpc("call_local", "any_peer", "reliable")
func _cache_method_rpc(method_name: String) -> void:
	if SD_Network.is_server():
		return
	
	get_cached_methods().append(method_name)

func serialize_method(callable: Callable) -> Variant:
	var id: int = get_cached_methods().find(callable.get_method())
	if id > -1:
		return id
	return callable.get_method()

func deserialize_method(serialized: Variant) -> Variant:
	if serialized is int:
		return get_cached_methods().get(serialized)
	return serialized

func _on_active_status_changed(status: bool) -> void:
	pass

func get_cached_nodes_by_id() -> Dictionary[int, NodePath]:
	return SD_Network.cache_get().get_or_add("cn_id", {} as Dictionary[int, NodePath]) as Dictionary[int, NodePath]

func get_cached_nodes_by_path() -> Dictionary[NodePath, int]:
	return SD_Network.cache_get().get_or_add("cn_path", {} as Dictionary[NodePath, int]) as Dictionary[NodePath, int]

func get_cached_path_by_id(id: int) -> NodePath:
	return get_cached_nodes_by_id().get(id, NodePath())

func get_cached_id_by_path(path: NodePath) -> int:
	return get_cached_nodes_by_path().get(path, -1)

func get_cached_id_by_node(node: Node) -> int:
	return get_cached_id_by_path(node.get_path())

func try_cache_node(node: Node) -> void:
	if not is_instance_valid(node):
		return
	
	if not SD_Network.is_server():
		return
	
	var cache_by_path: Dictionary[NodePath, int] = get_cached_nodes_by_path()
	var cache_by_id: Dictionary[int, NodePath] = get_cached_nodes_by_id()
	
	var net_id: int = node.get_instance_id()
	
	var path: NodePath = SD_NetRegisteredNode.get_or_create(node).last_path
	
	cache_by_path[path] = net_id
	cache_by_id[net_id] = path
	
	_client_cache.rpc(net_id, path)
	
	#debug_print("node cached: %s [%s]" % [str(path), str(net_id)], SD_ConsoleCategories.CATEGORY.INFO)

func try_uncache_node(path: NodePath) -> void:
	if not SD_Network.is_server():
		return
	
	var cache_by_path: Dictionary[NodePath, int] = get_cached_nodes_by_path()
	var cache_by_id: Dictionary[int, NodePath] = get_cached_nodes_by_id()
	var net_id: int = cache_by_path.get(path, -1)
	if net_id < 0:
		return
	
	cache_by_id.erase(net_id)
	cache_by_path.erase(path)
	
	_client_uncache.rpc(net_id, path)
	
	
	#debug_print("node removed from cache: %s [%s]" % [str(path), str(net_id)], SD_ConsoleCategories.CATEGORY.INFO)

func _on_scene_tree_node_added(node: Node) -> void:
	try_cache_node(node)

@rpc("any_peer", "reliable", "call_local")
func _client_recieve_changes(changes: Array[Dictionary]) -> void:
	if SD_Network.is_server():
		return
	
	for change in changes:
		if change.status:
			_client_cache(change.net_id, change.path)
		else:
			_client_uncache(change.net_id, change.path) 

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

func serialize_node_reference(node: Node) -> Variant:
	var reg: SD_NetRegisteredNode = SD_NetRegisteredNode.get_or_create(node)
	var path: NodePath = reg.last_path
	var id: int = get_cached_id_by_path(path)
	if id < 0:
		return path
	return id

func deserialize_node_reference(data: Variant) -> Node:
	if data is int:
		return get_node_or_null(get_cached_path_by_id(data))
	return get_node_or_null(data)
