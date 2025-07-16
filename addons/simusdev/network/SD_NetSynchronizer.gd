@icon("res://addons/simusdev/icons/Network.png")
extends Node
class_name SD_NetSynchronizer

#@export var enabled: bool = true
@export var _data: SD_NetSyncProperties

var _tickrate_data: Dictionary[int, float] = {}

var _is_cached: bool = false

var _channel_id: int = 0
var _channel_name: String = SD_NetTrunkCallables.CHANNEL_DEFAULT

var _channel_data: Dictionary[int, String] = {}

func get_tickrate_data() -> Dictionary[int, float]:
	return _tickrate_data

func get_synced_data(node: Node) -> Dictionary[String, Variant]:
	if node.has_meta("_netsynceddata"):
		return node.get_meta("_netsynceddata") as Dictionary[String, Variant]
	
	var data: Dictionary[String, Variant] = {}
	node.set_meta("_netsynceddata", data)
	return data

func get_hookchange_data(node: Node) -> Dictionary[String, Variant]:
	if node.has_meta("_nethookchange"):
		return node.get_meta("_nethookchange") as Dictionary[String, Variant]
	
	var data: Dictionary[String, Variant] = {}
	node.set_meta("_nethookchange", data)
	return data

func get_data() -> SD_NetSyncProperties:
	return _data

func set_data(new: SD_NetSyncProperties) -> void:
	if new:
		_data = new.duplicate()
		_data._synchronizer = self
		_data._ready()
		

func _ready() -> void:
	SD_Network.register_function(spti)
	SD_Network.register_function(rp)
	
	SD_Network.await_for_node_cache(self, _cached)
	
	

func _cached() -> void:
	_is_cached = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_data(_data)

func _process(delta: float) -> void:
	if _is_cached:
		if _data:
			_data._process(delta)

func _physics_process(delta: float) -> void:
	if _is_cached:
		if _data:
			_data._physics_process(delta)

#recieve property from

func _update_channel(property: SD_NetSyncedProperty) -> void:
	var p_id: int = _data.get_list().find(property)
	var c_name: String = _channel_data.get_or_add(p_id, SD_NetTrunkCallables.CHANNEL_DEFAULT)
	
	var id: int = property.channels.find(c_name)
	if id < 0:
		id = 0
	
	if id > property.channels.size() - 1:
		id = 0
	
	_channel_data.set(p_id, property.channels.get(id))
	

func rpf(peer: int, property: SD_NetSyncedProperty, apply_changes: bool = false) -> void:
	_update_channel(property)
	SD_Network.call_func_on(peer, spti, [SD_Network.get_unique_id(), _data.get_list().find(property), apply_changes, _channel_name], property.callmode, _channel_name)

#send property to
func spt(peer: int, property: SD_NetSyncedProperty, apply_changes: bool = false) -> void:
	_update_channel(property)
	spti(peer, _data.get_list().find(property), apply_changes, _channel_name)

#send property
func sp(property: SD_NetSyncedProperty, apply_changes: bool = false) -> void:
	for peer in SD_Network.get_peers():
		spti(peer, _data.get_list().find(property), apply_changes)

#send property to by id
func spti(peer: int, property_id: int, apply_changes: bool = false, channel: String = SD_NetTrunkCallables.CHANNEL_DEFAULT) -> void:
	var property: SD_NetSyncedProperty = SD_Array.get_value_from_array(_data.get_list(), property_id)
	if !property:
		return
	
	var node: Node = get_node_or_null(property.node_path)
	if !node:
		return
	
	var send_data: Dictionary = {}
	
	var p_id: int = 0
	for p_name in property.properties:
		send_data[p_id] = node.get(p_name)
		p_id += 1
	
	SD_Network.call_func_on(peer, rp, [property_id, send_data, apply_changes], property.callmode, channel)

#recieve properties
func rp(property_id: int, data: Dictionary, apply_changes: bool = false) -> void:
	var property: SD_NetSyncedProperty = SD_Array.get_value_from_array(_data.get_list(), property_id)
	if !property:
		return
	
	var node: Node = get_node_or_null(property.node_path)
	if !node:
		return
	
	var put_into_synced: bool = not (property.sync == property.SYNC.AUTHORITY and get_multiplayer_authority() == SD_Network.get_unique_id())
	
	var synced: Dictionary[String, Variant] = get_synced_data(node)
	
	for p_id in data:
		var p_name: String = property.properties.get(p_id)
		var value: Variant = data[p_id]
		
		if put_into_synced:
			synced[p_name] = value
		
		if apply_changes:
			node.set(p_name, value)
