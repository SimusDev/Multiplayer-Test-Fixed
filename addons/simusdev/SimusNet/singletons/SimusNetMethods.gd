extends SimusNetSingletonChild
class_name SimusNetMethods

const BYTES_SIZE: int = 2

static var _bytes: PackedByteArray = PackedByteArray()

static var _instance: SimusNetMethods
static var _event_cached: SimusNetEventMethodCached
static var _event_uncached: SimusNetEventMethodUncached

static func get_cached() -> PackedStringArray:
	return SimusNetCache.data_get_or_add("m", PackedStringArray())

static func get_id(callable: Callable) -> int:
	return get_cached().find(callable.get_method())

static func get_name_by_id(id: int) -> String:
	return get_cached().get(id)

static func serialize(callable: Callable) -> PackedByteArray:
	var method_id: int = get_id(callable)
	if method_id > -1:
		_bytes.clear()
		_bytes.resize(BYTES_SIZE)
		_bytes.encode_u16(0, method_id)
		return _bytes
	
	await _event_cached.published
	if _event_cached.method_name == callable.get_method():
		return await serialize(callable)
	return PackedByteArray()

static func deserialize(bytes: PackedByteArray) -> int:
	if bytes.is_empty():
		return -1
	return bytes.decode_u16(0)

static func try_serialize_into_variant(callable: Callable) -> Variant:
	var method_id: int = get_id(callable)
	if method_id > -1:
		return method_id
	return callable.get_method()

static func try_deserialize_from_variant(variant: Variant) -> String:
	if variant is int:
		return get_cached().get(variant)
	return variant as String

func initialize() -> void:
	_instance = self
	_event_cached = SimusNetEvents.event_method_cached
	_event_uncached = SimusNetEvents.event_method_uncached

static func cache(callable: Callable) -> void:
	if SimusNetConnection.is_server():
		if get_cached().has(callable.get_method()):
			return
		_instance._cache_rpc.rpc(callable.get_method())

@rpc("authority", "call_local", "reliable", SimusNetChannels.BUILTIN.CACHE)
func _cache_rpc(method: String) -> void:
	get_cached().append(method)
	_event_cached.method_name = method
	_event_cached.publish()

static func uncache(callable: Callable) -> void:
	if SimusNetConnection.is_server():
		if !get_cached().has(callable.get_method()):
			return
		
		_instance._uncache_rpc.rpc(callable.get_method())

@rpc("authority", "call_local", "reliable", SimusNetChannels.BUILTIN.CACHE)
func _uncache_rpc(method: String) -> void:
	get_cached().erase(method)
	_event_uncached.method_name = method
	_event_uncached.publish()
