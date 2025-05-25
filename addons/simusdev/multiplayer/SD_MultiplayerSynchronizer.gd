@icon("res://addons/simusdev/icons/MultiplayerSynchronizer.svg")
extends Node
class_name SD_MultiplayerSynchronizer

@export var _authority_node: Node
@export var sync_at_start: bool = true
@export var refresh_rate: float = 30
@export_enum("Idle", "Physics", "None") var send_mode: int = 0
@export_enum("After Sync", "Idle", "Physics", "None") var update_mode: int = 0

@export var interpolation: bool = false
@export var interpolation_speed: float = 30

@export_category("Synchronization")
@export var sync_node: Node
@export var properties_to_sync: PackedStringArray

var _current_interval: float = 0.0

var _synced_data: Dictionary[String, Variant] = {}

const HOST_ID: int = 1

signal synchronized()
signal data_created(data: Dictionary)
signal client_data_created(data: Dictionary)

func get_synced_data() -> Dictionary:
	return _synced_data

func set_authority_node(node: Node) -> void:
	_authority_node = node
	set_multiplayer_authority(_authority_node.get_multiplayer_authority())

func get_authority_node() -> Node:
	return _authority_node

func _ready() -> void:
	if _authority_node:
		set_multiplayer_authority(_authority_node.get_multiplayer_authority())
	else:
		set_multiplayer_authority(multiplayer.get_unique_id())
	
	if sync_at_start:
		sync(true)

func _process(delta: float) -> void:
	if send_mode == 0:
		_tick(delta)
	
	if update_mode == 1:
		update_properties_from_synced_data(delta)

func _physics_process(delta: float) -> void:
	if send_mode == 1:
		_tick(delta)
	
	if update_mode == 2:
		update_properties_from_synced_data(delta)

const INTERPOLATING_TYPES = [
	TYPE_INT,
	TYPE_FLOAT,
	TYPE_COLOR,
	TYPE_VECTOR2,
	TYPE_VECTOR2I,
	TYPE_VECTOR3,
	TYPE_VECTOR3I,
	TYPE_TRANSFORM2D,
	TYPE_TRANSFORM3D,
]
func update_properties_from_synced_data(delta: float = 0.0, synced_data: Dictionary = _synced_data, sync_instantly: bool = false) -> void:
	_synced_data = synced_data
	for property in _synced_data:
		var value: Variant = _synced_data[property]
		if not properties_to_sync.has(property):
			continue
		
		if (interpolation) and INTERPOLATING_TYPES.has(typeof(value)) and not sync_instantly:
			var lerp_speed: float = interpolation_speed * delta
			
			var actual_value: Variant = sync_node.get(property)
			actual_value = lerp(actual_value, value, lerp_speed)
			sync_node.set(property, actual_value)
		else:
			sync_node.set(property, value)
			

func _tick(delta: float) -> void:
	if refresh_rate == 0:
		sync(false)
		return
	
	var send_interval: float = float(1.0) / float(refresh_rate)
	_current_interval = move_toward(_current_interval, send_interval, delta)
	if _current_interval >= send_interval:
		sync(false)
		_current_interval = 0

func sync(instantly: bool = true) -> void:
	if (not sync_node):
		return
	
	_try_synchronize(instantly)


func create_new_synced_data() -> Dictionary[String, Variant]:
	var _data: Dictionary[String, Variant] = {}
	for property in properties_to_sync:
		_data[property] = sync_node.get(property)
	#_data["path"] = get_path()
	data_created.emit(_data)
	return _data

func create_new_client_data() -> Dictionary[String, Variant]:
	var _data: Dictionary[String, Variant] = {}
	#_data["path"] = get_path()
	return _data

func _try_synchronize(instantly: bool = false) -> void:
	var data: Dictionary = create_new_synced_data()
	if _authority_node:
		
		_sync_rpc.rpc(_authority_node.get_multiplayer_authority(), data, instantly)
		
		return
	
	data["path"] = get_path()
	_address_to_server(data, instantly)

func _address_to_server(data: Dictionary, instantly: bool = false) -> void:
	if multiplayer.is_server():
		return
	
	_send_data_to_server.rpc_id(1, data, instantly)

@rpc("any_peer")
func _send_data_to_server(data: Dictionary, instantly: bool = false) -> void:
	var synchronizer: SD_MultiplayerSynchronizer = get_node_or_null(data["path"])
	if synchronizer:
		var server_data: Dictionary = synchronizer.create_new_synced_data()
		_synchronize_without_authority_node.rpc(server_data, instantly)
	
@rpc("any_peer")
func _synchronize_without_authority_node(data: Dictionary, instantly: bool = false) -> void:
	update_properties_from_synced_data(0.0, data, instantly)

@rpc("any_peer")
func _sync_rpc(peer_id: int, data: Dictionary, instantly: bool = false) -> void:
	if is_multiplayer_authority():
		return
	
	if _authority_node.get_multiplayer_authority() == peer_id:
		_synced_data = data
