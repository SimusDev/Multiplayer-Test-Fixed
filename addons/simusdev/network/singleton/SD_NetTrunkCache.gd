extends SD_NetTrunk
class_name SD_NetTrunkCache

var _cached_input_map_string: Dictionary[StringName, int] = {}
var _cached_input_map_id: Dictionary[int, StringName] = {}

var _stream_peer_buffer: StreamPeerBuffer = StreamPeerBuffer.new()

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
	if !resource:
		return
	
	var path: String = resource.resource_path
	if path.is_empty():
		debug_print("cant cache resource without path: %s" % str(resource), SD_ConsoleCategories.ERROR)
		return
	
	var cache: PackedStringArray = SD_Network.get_cached_resources()
	if cache.has(path):
		return
	
	
	_cache_resource_rpc.rpc(path)

@rpc("call_local", "any_peer", "reliable", SD_NetworkSingleton.CHANNEL.RESOURCE)
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

func get_cached_variables() -> PackedStringArray:
	var cache := singleton.cache_get()
	if cache.has("v"):
		return cache["v"]
	var methods: PackedStringArray = PackedStringArray()
	cache.set("v", methods)
	return methods

func cache_method(method: Callable) -> void:
	var methods: PackedStringArray = get_cached_methods()
	var m_name: String = method.get_method()
	if methods.has(m_name):
		return
	
	methods.append(m_name)
	
	debug_print("method cached: %s" % m_name)
	
	_cache_method_rpc.rpc(m_name)


@rpc("call_local", "any_peer", "reliable", SD_NetworkSingleton.CHANNEL.METHOD)
func _cache_method_rpc(method_name: String) -> void:
	if SD_Network.is_server():
		return
	
	get_cached_methods().append(method_name)

func cache_variable(variable: String) -> void:
	var variables: PackedStringArray = get_cached_variables()
	if variables.has(variable):
		return
	
	variables.append(variable)
	
	debug_print("variable cached: %s" % variable)
	
	_cache_variable_rpc.rpc(variable)

@rpc("call_local", "any_peer", "reliable", SD_NetworkSingleton.CHANNEL.METHOD)
func _cache_variable_rpc(variable: String) -> void:
	if SD_Network.is_server():
		return
	
	get_cached_variables().append(variable)

func serialize_var(variable: String) -> Variant:
	var id: int = get_cached_variables().find(variable)
	if id > -1:
		return id
	return variable

func deserialize_var(serialized: Variant) -> Variant:
	if serialized is int:
		return get_cached_variables().get(serialized)
	return serialized

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

func try_cache_node(node: Object) -> void:
	if not is_instance_valid(node):
		return
	
	if not SD_Network.is_server():
		return
	
	var cache_by_path: Dictionary[NodePath, int] = get_cached_nodes_by_path()
	var cache_by_id: Dictionary[int, NodePath] = get_cached_nodes_by_id()
	
	var net_id: int = node.get_instance_id()
	if node is SD_NetworkedResource:
		net_id = (SD_NetworkedResource._cached_instances.size() + 1) * -1
	
	var net := SD_NetRegisteredNode.get_or_create(node)
	var path: NodePath = net.last_path
	
	#cache_by_path[path] = net_id
	#cache_by_id[net_id] = path
	
	_client_cache(net_id, path)
	
	_client_cache.rpc(net_id, path)
	
	#print("server: %s: " % [SD_Network.is_server()], path)
	
	#debug_print("node cached: %s [%s]" % [str(path), str(net_id)], SD_ConsoleCategories.CATEGORY.INFO)


@rpc("reliable", "authority", "call_remote", SD_NetworkSingleton.CHANNEL.NODE)
func _client_cache(net_id: int, path: NodePath) -> void:
	get_cached_nodes_by_id()[net_id] = path
	get_cached_nodes_by_path()[path] = net_id
	
	var node: Object = deserialize_node_reference(net_id)
	#print("server: %s, %s. " % [SD_Network.is_server(), path])
	if node:
		var net: SD_NetRegisteredNode = SD_NetRegisteredNode.get_or_create(node)
		net.net_id = net_id
		net.references_by_path[path] = net
		net.references_by_net_id[net_id] = net
		net.is_cached = true
		net.cached.emit()
		debug_print("object cached: %s" % path, SD_ConsoleCategories.CATEGORY.INFO)


func try_uncache_node(path: NodePath) -> void:
	if not SD_Network.is_server():
		return
	
	#await get_tree().create_timer(1).timeout
	
	var cache_by_path: Dictionary[NodePath, int] = get_cached_nodes_by_path()
	var cache_by_id: Dictionary[int, NodePath] = get_cached_nodes_by_id()
	var net_id: int = cache_by_path.get(path, -1)
	
	if net_id < 0:
		return
	
	#print(path)
	
	#cache_by_id.erase(net_id)
	#cache_by_path.erase(path)
	
	if is_inside_tree():
		_client_uncache(net_id, path)
		_client_uncache.rpc(net_id, path)
	
	#debug_print("node removed from cache: %s [%s]" % [str(path), str(net_id)], SD_ConsoleCategories.CATEGORY.INFO)

@rpc("reliable", "authority", "call_remote", SD_NetworkSingleton.CHANNEL.NODE)
func _client_uncache(net_id: int, path: NodePath) -> void:
	get_cached_nodes_by_id().erase(net_id)
	get_cached_nodes_by_path().erase(path)
	
	var node: Object = deserialize_node_reference(net_id)
	if node:
		var net: SD_NetRegisteredNode = SD_NetRegisteredNode.get_or_create(node)
		net.is_cached = false
		net.uncached.emit()
		debug_print("object uncached: %s" % path, SD_ConsoleCategories.CATEGORY.INFO)

func debug_print(text, category: int = 0) -> void:
	if singleton.settings.debug_cache:
		singleton.debug_print(text, category)

func serialize_node_reference(node: Object) -> Variant:
	var reg: SD_NetRegisteredNode = SD_NetRegisteredNode.get_or_create(node)
	if reg.is_cached:
		return reg.net_id
	
	var path: NodePath = reg.last_path
	var id: int = get_cached_id_by_path(path)
	if id < 0:
		return path
	return id

func deserialize_node_reference(data: Variant) -> Object:
	if data is int:
		var founded: Object
		
		founded = SD_NetworkedResource.deserialize_reference(data)
		
		if founded:
			return founded
		
		founded = get_node_or_null(get_cached_path_by_id(data))
		if founded:
			return founded
		
		founded = instance_from_id(data)
		if founded:
			return founded
		
		return SD_NetRegisteredNode.references_by_net_id.get(data)
	
	var founded: Object = get_node_or_null(data)
	if founded:
		return founded
	return SD_NetworkedResource.find_from_global_net_id(str(data))
