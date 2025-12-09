extends Node
class_name SD_NetworkPlayer

var resource: SD_NetPlayerResource
var _data: Dictionary = {}
var _peer: int = 1

var _server_data: Dictionary = {}

signal serverdata_changed(key: String, value: Variant)

var _rights: PackedStringArray = []

signal on_connected()
signal on_disconnected()

func _ready() -> void:
	SD_Network.register_object(self)
	#SD_Network.register_functions()
	
	process_mode = Node.PROCESS_MODE_DISABLED
	#set_process_internal(false)
	#set_physics_process_internal(false)
	
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	set_process_shortcut_input(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)
	

func set_rights(rights: PackedStringArray) -> void:
	if SD_Network.is_server():
		SD_Network.call_func(_set_rights_local, [rights])

func _set_rights_local(rights: PackedStringArray) -> void:
	_server_data.set("rights", rights)

func get_rights() -> PackedStringArray:
	return _server_data.get_or_add("rights", [] as PackedStringArray) as PackedStringArray

func has_right(right: String) -> bool:
	return get_rights().has(right)

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
