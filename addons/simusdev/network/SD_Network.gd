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

static var remote_sender: SD_NetSender = SD_NetSender.new()

func _init(net: SD_NetworkSingleton) -> void:
	singleton = net

static func is_authority(node: Node) -> bool:
	return node.get_multiplayer_authority() == get_unique_id()

static func terminate_connection() -> void:
	singleton.terminate_connection()

static func register_function(callable: Callable, options: Dictionary = {}) -> void:
	singleton.callables.register_function(callable, options)

static func register_functions(callables: Array[Callable]) -> void:
	for callable in callables:
		register_function(callable)

static func cache_function(callable: Callable) -> void:
	singleton.cache.cache_method(callable)

static func cache_functions(callables: Array[Callable]) -> void:
	for i in callables:
		cache_function(i)

static func register_all_functions(node: Node) -> void:
	singleton.callables.register_all_functions(node)

static func get_unique_id() -> int:
	return singleton.get_unique_id()

static func get_multiplayer_authority() -> int:
	return get_unique_id()

static func get_cached_resources() -> PackedStringArray:
	return singleton.get_cached_resources()

static func cache_set(new: Dictionary[String, Array]) -> void:
	singleton.cache_set(new)

static func cache_get() -> Dictionary[String, Variant]:
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

static func register_variable(node: Node, property: String, options: Dictionary = {}) -> void:
	singleton.variables.register_variable(node, property, options)

static func register_variables(node: Node, properties: PackedStringArray) -> void:
	for property in properties:
		register_variable(node, property)

static func register_all_variables(node: Node) -> void:
	singleton.variables.register_all_variables(node)

static func get_registered_variables(object: Object) -> Dictionary[String, Dictionary]:
	return singleton.variables.get_registered_variables(object)

static func is_variable_registered(node: Node, property: String) -> bool:
	return singleton.variables.is_variable_registered(node, property)

static func var_sync_from(peer: int, node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT, options: Dictionary = {}) -> SD_NetSyncedVars:
	return singleton.variables.var_sync_from(peer, node, properties, callmode, channel, options)

static func var_send_to(peer: int, node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT, options: Dictionary = {}) -> void:
	singleton.variables.var_send_to(peer, node, properties, callmode, channel, options)

static func var_sync_from_server(node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT, options: Dictionary = {}) -> SD_NetSyncedVars:
	return singleton.variables.var_sync_from_server(node, properties, callmode, channel, options)

static func get_remote_sender_id() -> int:
	return singleton.callables.get_remote_sender_id()

static func register_object(node: Node) -> void:
	singleton.register_object(node)

static func unregister_object(node: Node) -> void:
	singleton.unregister_object(node)

static func is_object_registered(node: Node) -> bool:
	return singleton.is_object_registered(node)

static func register_channel(name: String) -> void:
	singleton.callables.register_channel(name)
