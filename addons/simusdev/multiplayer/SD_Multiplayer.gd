
extends SD_Object
class_name SD_Multiplayer

static var _singleton: SD_MultiplayerSingleton

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

static func create_server(port: int) -> void:
	_singleton.create_server(port)

static func create_client(address: String, port: int) -> void:
	_singleton.create_client(address, port)

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

static func request_and_sync_var(node: Node, property: String, callable: Callable, reliable: bool, from_peer: int) -> void:
	_singleton.request_and_sync_var(node, property, callable, reliable, from_peer)

static func request_and_sync_var_from_server(node: Node, property: String, callable: Callable = Callable(), reliable: bool = true) -> void:
	_singleton.request_and_sync_var_from_server(node, property, callable, reliable)

static func sync_var(node: Node, property: String, override_var: Variant = null, reliable: bool = true) -> void:
	_singleton.sync_var(node, property, override_var, reliable)

static func sync_call_function(node: Node, callable: Callable, args: Array = [], reliable: bool = true) -> void:
	_singleton.sync_call_function(node, callable, args, reliable)
