extends SD_Object
class_name SD_MultiplayerPlayer

var _singleton: SD_MultiplayerSingleton

var _peer_id: int = -1

const HOST_ID: int = 1

var _data: SD_MPSyncedData

signal event_recieved(event: Variant, args: Variant)

func get_username() -> String:
	return get_data_value("_username_", "")

func set_username(name: String) -> void:
	set_data_value("_username_", name.replacen(" ", ""))

func get_data_value(key: String, default_value: Variant = null) -> Variant:
	if is_instance_valid(_data):
		return _data.get_data_value(key, default_value)
	return default_value

func set_data_value(key: String, value: Variant) -> void:
	if is_instance_valid(_data):
		_data.set_data_value(key, value)

func get_peer_id() -> int:
	return _peer_id

func is_host() -> bool:
	return _peer_id == HOST_ID

func initialize(singleton: SD_MultiplayerSingleton, peer_id: int, username: String) -> void:
	_singleton = singleton
	_peer_id = peer_id
	
	_data = SD_MPSyncedData.new()
	_data.start_node_name = str(peer_id)
	_data.set_multiplayer_authority(peer_id)
	singleton.add_child(_data)
	_data.set_data_value("_username_", username)

func is_multiplayer_authority() -> bool:
	return _data.is_multiplayer_authority()

func deinitialize() -> void:
	_data.queue_free()
	_data = null

var _node: Node

func set_player_node(node: Node) -> void:
	_node = node
	node.set_multiplayer_authority(get_peer_id())
	node.set_meta("SD_MultiplayerPlayer", self)

func get_player_node() -> Node:
	return _node

static func find_in_node(node: Node) -> SD_MultiplayerPlayer:
	if !node:
		return null
	
	if node.has_meta("SD_MultiplayerPlayer"):
		return node.get_meta("SD_MultiplayerPlayer")
	return null
