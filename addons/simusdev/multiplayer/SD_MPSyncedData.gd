extends Node
class_name SD_MPSyncedData

@onready var singleton: SD_MultiplayerSingleton = SD_Multiplayer.get_singleton()
@onready var console: SD_TrunkConsole = SimusDev.console

@export var reliable: bool = true
@export var sync_at_start: bool = true
@export var _data: Dictionary[String, Variant]
@export var start_node_name: String

var _is_initialized: bool = false
var _is_dynamic: bool = false

signal initialized()

signal all_data_synchronized()

signal data_changed(key: String, new_value: Variant)

func _enter_tree() -> void:
	if start_node_name.is_empty():
		return
	
	name = start_node_name
	name = name.validate_node_name()

func is_initialized() -> bool:
	return _is_initialized

func is_dynamic() -> bool:
	return _is_dynamic

func local_set_data(data: Dictionary) -> void:
	_data.clear()
	for key in data:
		_data[str(key)] = data[key]

func local_get_data() -> Dictionary[String, Variant]:
	return _data

func local_clear_data() -> void:
	_data.clear()

func local_get_data_value(key: String, default_value = null) -> Variant:
	return _data.get(key, default_value)

func get_data_value(key: String, default_value = null) -> Variant:
	return _data.get(key, default_value)

func set_data_value(key: String, value: Variant) -> void:
	if SD_Multiplayer.is_active():
		var packet: Dictionary = SD_Multiplayer.serialize_var_into_packet(value)
		var serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
		if reliable:
			_set_data_value_rpc_reliable.rpc(key, serialized)
		else:
			_set_data_value_rpc_unreliable.rpc(key, serialized)
	else:
		_data.set(key, value)
		data_changed.emit(key, value)
	

@rpc("any_peer", "call_local", "reliable")
func _set_data_value_rpc_reliable(key: String, serialized: Variant) -> void:
	var packet: Dictionary = SD_MPDataCompressor.deserialize_data(serialized)
	var value: Variant = SD_Multiplayer.deserialize_var_from_packet(packet)
	_data.set(key, value)
	data_changed.emit(key, value)


@rpc("any_peer", "call_local", "unreliable_ordered")
func _set_data_value_rpc_unreliable(key: String, serialized: Variant) -> void:
	var packet: Dictionary = SD_MPDataCompressor.deserialize_data(serialized)
	var value: Variant = SD_Multiplayer.deserialize_var_from_packet(packet)
	_data.set(key, value)
	data_changed.emit(key, value)


func _ready() -> void:
	_initialize()

func _initialize() -> void:
	if _is_initialized:
		return
	
	singleton.connected_to_server.connect(_on_connected_to_server)
	
	if sync_at_start:
		synchronize_all_data()
	
	if multiplayer.is_server():
		_is_initialized = true
		initialized.emit()

func synchronize_all_data() -> void:
	client_sync_data_from_server()
	if singleton.is_server():
		all_data_synchronized.emit()

func _on_connected_to_server() -> void:
	synchronize_all_data()

func client_sync_data_from_server() -> void:
	if singleton.is_server():
		return
	
	_client_sync_data_from_server_rpc.rpc_id(singleton.HOST_ID)


@rpc("any_peer", "reliable", "call_local")
func _client_sync_data_from_server_rpc() -> void:
	if singleton.is_server():
		var server_data: Dictionary[String, Variant] = local_get_data()
		
		var client_id: int = multiplayer.get_remote_sender_id()
		
		var packet: Dictionary = SD_Multiplayer.serialize_var_into_packet(server_data)
		var serialized: Variant = SD_MPDataCompressor.serialize_data(packet)
		
		_client_recive_data_from_server_rpc.rpc_id(client_id, serialized)

@rpc("any_peer", "reliable")
func _client_recive_data_from_server_rpc(serialized: Variant) -> void:
	_is_initialized = true
	initialized.emit()
	
	var packet: Dictionary = SD_MPDataCompressor.deserialize_data(serialized)
	var recieved_data: Variant = SD_Multiplayer.deserialize_var_from_packet(packet)
	local_set_data(recieved_data)
	all_data_synchronized.emit()

static func create_dynamic_data(node: Node) -> SD_MPSyncedData:
	if is_node_has_dynamic_data(node):
		return get_node_dynamic_data(node)
	
	var data: SD_MPSyncedData = SD_MPSyncedData.new()
	data._is_dynamic = true
	data.name = "mp_dsync_data"
	data.name = data.name.validate_node_name()
	node.set_meta("mp_dsync_data", data)
	node.add_child(data)
	return data

static func get_node_dynamic_data(node: Node) -> SD_MPSyncedData:
	if node.has_meta("mp_dsync_data"):
		return node.get_meta("mp_dsync_data", null)
	return null

static func is_node_has_dynamic_data(node: Node) -> bool:
	return get_node_dynamic_data(node) != null
