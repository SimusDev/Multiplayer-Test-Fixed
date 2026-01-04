extends SimusNetSingletonChild
class_name SimusNetCache

static var instance: SimusNetCache

var _data: Dictionary[String, Variant] = {} 

static func get_data() -> Dictionary[String, Variant]:
	return instance._data

static func _set_data(new: Dictionary[String, Variant]) -> void:
	instance._data = new

static func data_get_or_add(key: String, default: Variant = null) -> Variant:
	var dict: Dictionary[String, Variant] = get_data()
	if dict.has(key):
		return dict.get(key)
	
	dict.set(key, default)
	return default
	

static func clear() -> void:
	get_data().clear()

func initialize() -> void:
	instance = self

static func _cache_identity(identity: SimusNetIdentity) -> void:
	if SimusNetConnection.is_server():
		instance._cache_identity_rpc.rpc(identity.get_generated_unique_id(), identity.get_unique_id())

@rpc("authority", "call_local", "reliable", SimusNetChannels.BUILTIN.IDENTITY)
func _cache_identity_rpc(generated_id: Variant, unique_id: int) -> void:
	SimusNetIdentity.get_cached_unique_ids_values().set(generated_id, unique_id)
	SimusNetIdentity.get_cached_unique_ids().set(unique_id, generated_id)
	SimusNetEvents.event_identity_cached.generated_unique_id = generated_id
	SimusNetEvents.event_identity_cached.unique_id = unique_id
	SimusNetEvents.event_identity_cached.publish()

static func _uncache_identity(identity: SimusNetIdentity) -> void:
	if SimusNetConnection.is_server():
		identity.get_cached_unique_ids().erase(identity.get_unique_id())
		identity.get_cached_unique_ids_values().erase(identity.get_generated_unique_id())
