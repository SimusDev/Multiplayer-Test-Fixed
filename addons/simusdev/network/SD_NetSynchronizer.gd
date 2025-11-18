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
		for p in new.get_list():
			for channel in p.channels:
				SD_Network.register_channel(channel)
		_data._ready()
		

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.singleton.variables.register_recieve_var_callback(_var_recieved)
	_cached()

func _cached() -> void:
	_is_cached = true
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
	

func recieve_property_from(peer: int, property: SD_NetSyncedProperty) -> void:
	_update_channel(property)
	SD_Network.var_sync_from(peer, get_node_or_null(property.node_path), property.properties, property.callmode, _channel_name)

#send property to
func send_property_to(peer: int, property: SD_NetSyncedProperty) -> void:
	_update_channel(property)
	SD_Network.var_send_to(peer, get_node_or_null(property.node_path), property.properties, property.callmode, _channel_name)

#send property
func send_property(property: SD_NetSyncedProperty) -> void:
	for peer in SD_Network.get_peers():
		send_property_to(peer, property)

func _var_recieved(from_peer: int, node: Node, properties: Dictionary) -> void:
	var sync_properties: Array[SD_NetSyncedProperty] = []
	
	var r_properties: PackedStringArray = PackedStringArray(properties.keys()).duplicate()
	
	#print(properties)
	
	for sp in _data.get_list():
		var sp_properties: PackedStringArray = sp.properties.duplicate()
		
		sp_properties.sort()
		r_properties.sort()
		
		if get_path_to(node) == sp.node_path:
			if sp_properties == r_properties:
				sync_properties.append(sp)
			
			
			
	
	for sync_property in sync_properties:
		var sync_node: Node = get_node_or_null(sync_property.node_path)
		var put_into_synced: bool = not (sync_property.sync == sync_property.SYNC.AUTHORITY and get_multiplayer_authority() == SD_Network.get_unique_id())
		
		var synced: Dictionary[String, Variant] = get_synced_data(sync_node)
		
		for p_name: String in properties:
			var p_value: Variant = properties[p_name]
			
			if put_into_synced:
				synced[p_name] = p_value
			
			if not sync_property.interpolation_enabled and put_into_synced:
				sync_node.set(p_name, p_value)
	
	
	
	
