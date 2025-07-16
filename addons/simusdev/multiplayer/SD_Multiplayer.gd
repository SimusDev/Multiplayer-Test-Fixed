@static_unload
extends SD_Object
class_name SD_Multiplayer

static var _singleton: SD_MultiplayerSingleton

const SERVER_ID: int = 1

enum CALLMODE {
	RELIABLE,
	UNRELIABLE,
	UNRELIABLE_ORDERED,
}

func _init(s: SD_MultiplayerSingleton) -> void:
	_singleton = s

static func get_singleton() -> SD_MultiplayerSingleton:
	return _singleton

static func is_active() -> bool:
	return _singleton.is_active()

static func update_connected_players() -> void:
	_singleton.update_connected_players()

static func get_player_by_peer_id(id: int) -> SD_MultiplayerPlayer:
	return _singleton.get_player_by_peer_id(id)

static func get_connected_players() -> Array[SD_MultiplayerPlayer]:
	return _singleton.get_connected_players()

static func get_authority_player() -> SD_MultiplayerPlayer:
	return _singleton.get_authority_player()

static func is_connected_to_server() -> bool:
	return _singleton.is_connected_to_server()

static func get_username() -> String:
	return _singleton.get_username()

static func set_username(new_name: String) -> void:
	_singleton.set_username(new_name)

static func get_peer() -> ENetMultiplayerPeer:
	return _singleton.get_peer()

static func close_server() -> void:
	_singleton.close_server()

static func create_server(port: int, dedicated: bool = false) -> void:
	_singleton.create_server(port, dedicated)

static func create_client(address: String, port: int) -> void:
	_singleton.create_client(address, port)

static func close_peer() -> void:
	SD_Network.singleton.terminate_connection()

static func close_client() -> void:
	_singleton.close_client()

static func get_connected_peers() -> PackedInt32Array:
	return _singleton.get_connected_peers()

static func is_server() -> bool:
	return _singleton.is_server()

static func is_not_server() -> bool:
	return _singleton.is_not_server()

static func is_client() -> bool:
	return _singleton.is_client()

static func is_dedicated_server() -> bool:
	return _singleton.is_dedicated_server()

static func set_dedicated_server(value: bool) -> void:
	return _singleton.set_dedicated_server(value)

static func request_and_sync_var(node: Node, property: String, callable: Callable, reliable: bool, from_peer: int) -> void:
	_singleton.request_and_sync_var(node, property, callable, reliable, from_peer)

static func request_and_sync_vars(node: Node, properties: Array[String], callable: Callable, reliable: bool, from_peer: int) -> void:
	_singleton.request_and_sync_vars(node, properties, callable, reliable, from_peer)

static func request_and_sync_vars_from_server(node: Node, properties: Array[String], callable: Callable = Callable(), reliable: bool = true) -> void:
	_singleton.request_and_sync_vars_from_server(node, properties, callable, reliable)

static func request_and_sync_var_from_server(node: Node, property: String, callable: Callable = Callable(), reliable: bool = true) -> void:
	_singleton.request_and_sync_var_from_server(node, property, callable, reliable)

static func send_and_sync_var(node: Node, property: String, reliable: bool, to_peer: int) -> void:
	_singleton.send_and_sync_var(node, property, reliable, to_peer)

static func send_and_sync_var_to_server(node: Node, property: String, reliable: bool = true) -> void:
	_singleton.send_and_sync_var_to_server(node, property, reliable)

static func send_and_sync_var_to_all_peers(node: Node, property: String, reliable: bool = true) -> void:
	_singleton.send_and_sync_var_to_all_peers(node, property, reliable)

static func sync_call_function(node: Node, callable: Callable, args: Array = [], callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.sync_call_function(node, callable, args, callmode)

static func sync_call_function_except_self(node: Node, callable: Callable, args: Array = [], callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.sync_call_function_except_self(node, callable, args, callmode)

static func sync_call_function_on_peer(peer: int, node: Node, callable: Callable, args: Array = [], callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.sync_call_function_on_peer(peer, node, callable, args, callmode)

static func sync_call_function_on_server(node: Node, callable: Callable, args: Array = [], callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.sync_call_function_on_server(node, callable, args, callmode)

static func call_func(callable: Callable, args: Array = [], callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.call_func(callable, args, callmode)

static func call_func_on(peer: int, callable: Callable, args: Array = [], callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.call_func_on(peer, callable, args, callmode)

static func call_func_on_server(callable: Callable, args: Array = [], callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.call_func_on_server(callable, args, callmode)

static func call_func_except_self(callable: Callable, args: Array = [], callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.call_func_except_self(callable, args, callmode)

static func request_response_from_peer(peer_id: int, result: Callable, timeout: float = 0.0,  reliable: bool = true) -> void:
	_singleton.request_response_from_peer(peer_id, result, timeout, reliable)

static func request_response_from_server(result: Callable, timeout: float = 0.0,  reliable: bool = true) -> void:
	_singleton.request_response_from_server(result, timeout, reliable)

static func request_node_existence(node: Node, result: Callable, args: Array, peer: int, reliable: bool) -> void:
	_singleton.request_node_existence(node, result, args, peer, reliable)

static func request_node_existence_from_server(node: Node, result: Callable, args: Array = [], reliable: bool = true) -> void:
	_singleton.request_node_existence_from_server(node, result, args, reliable)

static func serialize_object_var_into_packet(object: Object, property: String) -> Dictionary[String, Variant]:
	return _singleton.serialize_object_var_into_packet(object, property)

static func serialize_var_into_packet(variable: Variant) -> Variant:
	return _singleton.serialize_var_into_packet(variable)

static func deserialize_var_from_packet(serialized: Dictionary) -> Variant:
	return _singleton.deserialize_var_from_packet(serialized)

static func get_unique_id() -> int:
	return _singleton.get_unique_id()

static func get_multiplayer_authority() -> int:
	return get_unique_id()

static func kick_peer(peer: int) -> void:
	_singleton.kick_peer(peer)

static func kick(player: SD_MultiplayerPlayer) -> void:
	_singleton.kick(player)

static func is_authority(node: Node) -> bool:
	return _singleton.is_authority(node)

static func throw_event(event: Variant, args: Variant = null, callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.throw_event(event, args, callmode)

static func throw_event_on_server(event: Variant, args: Variant = null, callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.throw_event_on_server(event, args, callmode)

static func throw_event_on_player(player: SD_MultiplayerPlayer, event: Variant, args: Variant = null, callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.throw_event_on_player(player, event, args, callmode)

static func throw_event_on_peer(peer: int, event: Variant, args: Variant = null, callmode: CALLMODE = CALLMODE.RELIABLE) -> void:
	_singleton.throw_event_on_peer(peer, event, args, callmode)

static func bind_events(callable: Callable) -> void:
	_singleton.bind_events(callable)
