extends SimusNetSingletonChild
class_name SimusNetResources

static var _instance: SimusNetResources

static func get_cached() -> PackedStringArray:
	return SimusNetCache.data_get_or_add("r", PackedStringArray())

func initialize() -> void:
	_instance = self

static func get_unique_path(resource: Resource) -> String:
	var uuid: String = ""
	if !resource.resource_path.is_empty():
		uuid = ResourceUID.path_to_uid(resource.resource_path)
	if uuid.is_empty():
		_instance.logger.push_error("failed get unique path: %s, %s" % [resource, resource.resource_path])
	return uuid

static func get_unique_id(resource: Resource) -> int:
	var uuid: String = get_unique_path(resource)
	var id: int = get_cached().find(uuid)
	if id < 0:
		_instance.logger.push_error("failed get unique id: %s" % resource)
	return id

static func cache(resource: Resource) -> void:
	if SimusNetConnection.is_server():
		var path: String = get_unique_path(resource)
		if path.is_empty():
			return
		
		if get_cached().has(path):
			return
		
		_instance._cache_rpc.rpc(path)

@rpc("authority", "call_local", "reliable", SimusNetChannels.BUILTIN.CACHE)
func _cache_rpc(path: String) -> void:
	get_cached().append(path)

static func uncache(resource: Resource) -> void:
	if SimusNetConnection.is_server():
		var path: String = get_unique_path(resource)
		if path.is_empty():
			return
		
		if !get_cached().has(path):
			return
		
		_instance._uncache_rpc.rpc(path)

@rpc("authority", "call_local", "reliable", SimusNetChannels.BUILTIN.CACHE)
func _uncache_rpc(path: String) -> void:
	get_cached().erase(path)
