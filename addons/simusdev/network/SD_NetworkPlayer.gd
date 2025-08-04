extends Node
class_name SD_NetworkPlayer

var resource: SD_NetPlayerResource
var _data: Dictionary = {}
var _peer: int = 1

var _server_data: Dictionary = {}

signal serverdata_changed(key: String, value: Variant)

func serverdata_set_value(key: Variant, value: Variant) -> void:
	if SD_Network.is_server():
		SD_Network.call_func_on_server(_s_serverdata_set_value, [key, value])

func _s_serverdata_set_value(key: Variant, value: Variant) -> void:
	SD_Network.call_func(_s_serverdata_recieve_changes, [key, value])

func _s_serverdata_recieve_changes(key: Variant, value: Variant) -> void:
	_server_data[key] = value
	serverdata_changed.emit(key, value)

func serverdata_get_value(key: Variant, default: Variant = null) -> Variant:
	return _server_data.get(key, default)

func get_username() -> String:
	return _data.get("_username", "")

func get_nickname() -> String:
	return get_username()

func get_unique_id() -> int:
	return _peer

func get_peer_id() -> int:
	return _peer

var _node: Node

func set_in(node: Node) -> void:
	node.set_meta("network_player", get_peer_id())
	_node = node
	_node.set_multiplayer_authority(get_peer_id())

static func get_local() -> SD_NetworkPlayer:
	return get_by_peer_id(SD_Network.get_unique_id())

static func find_in(node: Node) -> SD_NetworkPlayer:
	if node.has_meta("network_player"):
		return get_by_peer_id(node.get_meta("network_player"))
	return null

func get_player_node() -> Node:
	return _node

static func get_by_peer_id(id: int) -> SD_NetworkPlayer:
	return SD_Network.get_players().get(id)
