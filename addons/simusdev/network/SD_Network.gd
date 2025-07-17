@static_unload
extends SD_Object
class_name SD_Network

static var singleton: SD_NetworkSingleton

enum CALLMODE {
	RELIABLE,
	UNRELIABLE,
	UNRELIABLE_ORDERED,
}

const SERVER_ID: int = 1

func _init(net: SD_NetworkSingleton) -> void:
	singleton = net

static func terminate_connection() -> void:
	singleton.terminate_connection()

static func register_function(callable: Callable, options: Dictionary = {}) -> void:
	singleton.callables.register_function(callable, options)

static func register_all_functions(node: Node) -> void:
	singleton.callables.register_all_functions(node)

static func get_unique_id() -> int:
	return singleton.get_unique_id()

static func get_multiplayer_authority() -> int:
	return get_unique_id()

static func get_cached_nodes() -> Array[String]:
	return singleton.get_cached_nodes()

static func get_cached_resources() -> Array[String]:
	return singleton.get_cached_resources()

static func cache_set(new: Dictionary[String, Array]) -> void:
	singleton.cache_set(new)

static func cache_get() -> Dictionary[String, Array]:
	return singleton.cache_get()

static func get_peers() -> PackedInt32Array:
	return singleton.get_peers()

static func get_players() -> Dictionary[int, SD_NetworkPlayer]:
	return singleton.players.get_connected()

static func get_player_list() -> Array[SD_NetworkPlayer]:
	return get_players().values() as Array[SD_NetworkPlayer]

static func get_connected_players() -> Array[SD_NetworkPlayer]:
	return get_player_list()

static func create_server(port: int, max_clients: int = 32) -> bool:
	return singleton.server.create(port, max_clients)

static func create_client(address: String, port: int) -> bool:
	return singleton.client.create(address, port)

static func is_server() -> bool:
	return singleton.is_server()

static func is_dedicated_server() -> bool:
	return singleton.is_dedicated_server()

static func is_client() -> bool:
	return singleton.is_client()

static func set_username(new: String) -> void:
	singleton.set_username(new)

static func get_username() -> String:
	return singleton.get_username()

static func call_func_on(peer: int, callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	singleton.callables.call_func_on(peer, callable, args, callmode, channel)

static func call_func(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	singleton.callables.call_func(callable, args, callmode, channel)

static func call_func_except_self(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	singleton.callables.call_func_except_self(callable, args, callmode, channel)

static func call_func_on_server(callable: Callable, args: Array = [], callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	singleton.callables.call_func_on_server(callable, args, callmode, channel)

static func is_node_cached(node: Node) -> bool:
	return get_cached_nodes().has(str(node.get_path()))

static func await_for_node_cache(node: Node, callable: Callable) -> void:
	callable.call()
	return
	
	if is_node_cached(node):
		callable.call()
		return
	
	var path: String = str(node.get_path())
	singleton.on_cached_node_recieve.connect(_on_cached_node_recieve.bind(path, callable))

static func _on_cached_node_recieve(path: String, target: String, callable: Callable) -> void:
	if path == target:
		singleton.on_cached_node_recieve.disconnect(_on_cached_node_recieve)
		callable.call()
