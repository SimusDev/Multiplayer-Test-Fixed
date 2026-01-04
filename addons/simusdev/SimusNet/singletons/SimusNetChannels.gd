extends SimusNetSingletonChild
class_name SimusNetChannels

const MAX: int = 72

enum BUILTIN {
	HANDSHAKE = MAX,
	CACHE,
	REGISTER,
	IDENTITY,
	VISIBILITY,
}

const DEFAULT: String = "main"
const DEFAULT_ID: int = 0

static var _instance: SimusNetChannels

func initialize() -> void:
	_instance = self
	
	register(DEFAULT)

static func parse_and_get_id(channel: Variant) -> int:
	if channel is int:
		return channel
	if channel is String:
		return get_id(channel)
	return DEFAULT_ID

static func get_list() -> PackedStringArray:
	return SimusNetCache.data_get_or_add("cns", PackedStringArray())

static func get_id(channel: String) -> int:
	var founded: int = get_list().find(channel)
	if founded < 0:
		founded = 0
	return founded

static func get_name_by_id(id: int) -> String:
	return get_list().get(id)

static func register(c_name: String) -> void:
	if get_list().size() >= MAX:
		_instance.logger.debug_error("cant create channel (%s), reached max channels limit(%s)!" % [c_name, MAX])
		return
	
	if SimusNetConnection.is_server():
		_instance._register_rpc.rpc(c_name)

@rpc("authority", "call_local", "reliable", BUILTIN.REGISTER)
func _register_rpc(c_name: String) -> void:
	get_list().append(c_name)

static func unregister(c_name: String) -> void:
	if SimusNetConnection.is_server():
		_instance._unregister_rpc.rpc(c_name)

@rpc("authority", "call_local", "reliable", BUILTIN.REGISTER)
func _unregister_rpc(c_name: String) -> void:
	get_list().erase(c_name)
