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

static func parse_callmode_into_transfer_mode(callmode: CALLMODE) -> MultiplayerPeer.TransferMode:
	if callmode == CALLMODE.RELIABLE:
		return MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE
	elif callmode == CALLMODE.UNRELIABLE:
		return MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE
	return MultiplayerPeer.TransferMode.TRANSFER_MODE_UNRELIABLE_ORDERED

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

static func var_sync_from(peer: int, node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> SD_NetSyncedVars:
	return singleton.variables.var_sync_from(peer, node, properties, callmode, channel)

static func var_send_to(peer: int, node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	singleton.variables.var_send_to(peer, node, properties, callmode, channel)

static func var_sync_from_server(node: Node, properties: PackedStringArray, callmode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> SD_NetSyncedVars:
	return singleton.variables.var_sync_from_server(node, properties, callmode, channel)

static func get_remote_sender_id() -> int:
	return singleton.callables.get_remote_sender_id()

static func register_object(node: Object, allow_inactive: bool = true) -> SD_NetRegisteredNode:
	return singleton.register_object(node, allow_inactive)

static func unregister_object(node: Object) -> void:
	singleton.unregister_object(node)

static func is_object_registered(object: Object) -> bool:
	return singleton.is_object_registered(object)

static func register_channel(name: String) -> void:
	singleton.callables.register_channel(name)

static func is_player(node: Node) -> bool:
	return SD_NetworkPlayer.get_local().get_player_node() == node

static func is_player_and_authority(node: Node) -> bool:
	return SD_NetworkPlayer.get_local().get_player_node() == node and SD_Network.is_authority(node)

static func register_rpc(callable: Callable, 
rpc_mode: MultiplayerAPI.RPCMode = MultiplayerAPI.RPCMode.RPC_MODE_AUTHORITY,
transfer_mode: MultiplayerPeer.TransferMode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE,
channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	singleton.rpc.register_rpc(callable, rpc_mode, transfer_mode, channel)

static func register_rpc_any_peer(callable: Callable, transfer_mode: MultiplayerPeer.TransferMode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	register_rpc(callable, MultiplayerAPI.RPC_MODE_ANY_PEER, transfer_mode, channel)

static func register_rpc_authority(callable: Callable, transfer_mode: MultiplayerPeer.TransferMode = MultiplayerPeer.TransferMode.TRANSFER_MODE_RELIABLE, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	register_rpc(callable, MultiplayerAPI.RPC_MODE_AUTHORITY, transfer_mode, channel)

static func unregister_rpc(callable: Callable) -> void:
	singleton.rpc.unregister_rpc(callable)

static func call_rpc(callable: Callable, args: Array = []) -> void:
	singleton.rpc.call_rpc(callable, args)

static func call_rpc_except_self(callable: Callable, args: Array = []) -> void:
	singleton.rpc.call_rpc_except_self(callable, args)

static func call_rpc_on(peer: int, callable: Callable, args: Array = []) -> void:
	singleton.rpc.call_rpc_on(peer, callable, args)

static func call_rpc_on_server(callable: Callable, args: Array = []) -> void:
	singleton.rpc.call_rpc_on_server(callable, args)

static func replicate_vars(object: Object, vars: PackedStringArray, mode: SD_Network.CALLMODE = SD_Network.CALLMODE.RELIABLE, channel: String = SD_NetTrunkVariables.CHANNEL) -> void:
	singleton.variables.replicate(object, vars, mode, channel)
