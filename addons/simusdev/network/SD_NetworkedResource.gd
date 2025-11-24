extends Resource
class_name SD_NetworkedResource

@export_group("Network")
@export var net_id: StringName = ""

static var _cached_id: Dictionary[StringName, SD_NetworkedResource] = {}
static var _cached_instances: Dictionary[SD_NetworkedResource, StringName] = {}

signal registered()
signal unregistered()

var is_registered: bool = false

static func _cache_get_paths() -> Dictionary[StringName, int]:
	if SD_Network.cache_get().has("n.r.p"):
		return SD_Network.cache_get().get("n.r.p", {})
	var cache: Dictionary[StringName, int] = {}
	return cache
	
static func _cache_get_id() -> Dictionary[int, StringName]:
	if SD_Network.cache_get().has("n.r.i"):
		return SD_Network.cache_get().get("n.r.i", {})
	var cache: Dictionary[int, StringName] = {}
	return cache

static func find_from_global_net_id(id: StringName) -> SD_NetworkedResource:
	return _cached_id.get(id)

func serialize_reference() -> int:
	return _cache_get_paths().get(net_id)

static func deserialize_reference(ref: int) -> SD_NetworkedResource:
	var founded: Variant = SD_NetworkedResource._cache_get_id().get(ref)
	if founded != null:
		find_from_global_net_id(founded)
	return null

func register() -> void:
	if is_registered:
		return
	
	#SD_Network.register_object(self)
	
	_registered()

func unregister() -> void:
	if !is_registered:
		return
	
	#SD_Network.unregister_object(self)
	
	_unregistered()

func _registered() -> void:
	pass

func _unregistered() -> void:
	pass
