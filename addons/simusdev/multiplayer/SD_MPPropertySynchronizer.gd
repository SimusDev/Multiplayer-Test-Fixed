@icon("res://addons/simusdev/icons/MultiplayerSynchronizer.svg")
extends Node
class_name SD_MPPropertySynchronizer

#region VARIABLES

@export var properties: Array[SD_MPPSSyncedBase]

var _singleton: SD_MultiplayerSingleton

var _synced_data: Dictionary[Node, Dictionary]
var _synced_bases: Dictionary[Node, Array]

func set_synced_data_property(node: Node, property: String, value: Variant) -> void:
	var properties: Dictionary = get_synced_data_properties(node)
	properties[property] = value

func get_synced_data_property(node: Node, property: String, default_value: Variant = null) -> Variant:
	var properties: Dictionary = get_synced_data_properties(node)
	return properties.get(property, default_value)
	

func get_synced_data_properties(node: Node) -> Dictionary:
	var properties: Dictionary = _synced_data.get_or_add(node, {}) as Dictionary
	return properties
	
func get_synced_base(node: Node) -> Array[SD_MPPSSyncedBase]:
	return _synced_bases.get_or_add(node, [] as Array[SD_MPPSSyncedBase])

#endregion


#region SIGNALS
signal property_recieved(node: Node, property: String, value: Variant, from_peer: int)
signal property_sent(node: Node, property: String, value: Variant, to_peer: int)
#endregion

func get_synced_data() -> Dictionary[Node, Dictionary]:
	return _synced_data

func _ready() -> void:
	if not SD_Multiplayer.is_active():
		set_process(false)
		set_physics_process(false)
		return
	
	_singleton = SD_MultiplayerSingleton.get_instance()
	if not is_instance_valid(_singleton):
		SimusDev.console.write_from_object(self, "initialization failed! can't find SD_MultiplayerSingleton instance!", SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	
	for mp_property in properties:
		var node: Node = get_node(mp_property.node_path)
		if node:
			if not _synced_bases.has(node):
				_synced_bases[node] = [] as Array[SD_MPPSSyncedBase]
			var array: Array[SD_MPPSSyncedBase] = _synced_bases[node]
			array.append(mp_property)
		
		if mp_property is SD_MPPSSyncedProperty:
			var hook_properties: Dictionary = _mp_node_properties_hook.get_or_add(mp_property, {}) as Dictionary
			if hook_properties:
				for property in mp_property.properties:
					hook_properties.set(property, node.get(property))
			if mp_property.sync_at_start:
				synchronize(mp_property)

var _existable_nodes: Array[String] = []

func synchronize_all() -> void:
	for mp_property in properties:
		synchronize(mp_property)

func synchronize(mp_property: SD_MPPSSyncedBase) -> void:
	var node: Node = get_node_or_null(mp_property.node_path)
	if not node:
		return
	
	#print(node)
	
	if SD_Multiplayer.is_active():
		match mp_property.mode:
			SD_MPPSSyncedProperty.MODE.FROM_SERVER:
				if multiplayer.is_server():
					if mp_property is SD_MPPSSyncedProperty:
						for peer in multiplayer.get_peers():
							if peer == SD_MultiplayerSingleton.HOST_ID:
								continue
							for property in mp_property.properties:
								send_property_to_peer_synced_data(node, property, node.get(property), peer, mp_property.reliable)
						
			
			SD_MPPSSyncedProperty.MODE.AUTHORITY:
				if is_multiplayer_authority():
					if mp_property is SD_MPPSSyncedProperty:
						for peer in multiplayer.get_peers():
							if peer == multiplayer.get_unique_id():
								continue
							for property in mp_property.properties:
								send_property_to_peer_synced_data(node, property, node.get(property), peer, mp_property.reliable)
						



#region REFRESHING

func _process(delta: float) -> void:
	for mp in properties:
		if mp is SD_MPPSSyncedProperty:
			if mp.tickrate_mode == mp.TICKRATE_MODE.IDLE and (mp.sync_mode == mp.SYNC_MODE.ALWAYS):
				_refresh(mp, delta)
			else:
				_hook_property_node_property_change(mp, delta)
	
	_interpolate(delta)

var _mp_node_properties_hook: Dictionary[SD_MPPSSyncedProperty, Dictionary]
func _hook_property_node_property_change(mp_property: SD_MPPSSyncedProperty, delta: float) -> void:
	var node: Node = get_node_or_null(mp_property.node_path)
	var properties: Dictionary = _mp_node_properties_hook.get_or_add(mp_property, {}) as Dictionary
	for property in properties:
		var property_value: Variant = properties.get(property, null)
		if property_value != node.get(property):
			synchronize(mp_property)
			properties.set(property, node.get(property))

func _physics_process(delta: float) -> void:
	for mp in properties:
		if mp is SD_MPPSSyncedProperty:
			if mp.tickrate_mode == mp.TICKRATE_MODE.PHYSICS:
				if mp.sync_mode == mp.SYNC_MODE.ALWAYS:
					_refresh(mp, delta)
	

var _mp_properties_cooldown: Dictionary[SD_MPPSSyncedProperty, float] = {}

func _refresh(mp_property: SD_MPPSSyncedProperty, delta: float) -> void:
	var current_cooldown: float = _mp_properties_cooldown.get_or_add(mp_property, 0.0)
	current_cooldown = move_toward(current_cooldown, 0.0, delta)
	_mp_properties_cooldown.set(mp_property, current_cooldown)
	
	if current_cooldown <= 0.0:
		current_cooldown = mp_property.get_tickrate_in_seconds()
		
		_mp_properties_cooldown.set(mp_property, current_cooldown)
		synchronize(mp_property)
		return
	
	
#endregion

#region INTERPOLATION
const INTERPOLATING_VARTYPES = [
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

func _interpolate(delta: float) -> void:
	for node in _synced_bases:
		var synced_bases: Array[SD_MPPSSyncedBase] = get_synced_base(node)
		for synced_base in synced_bases:
			if synced_base is SD_MPPSSyncedProperty:
				for property in synced_base.properties:
					var synced_value: Variant = get_synced_data_property(node, property, node.get(property))
					if synced_base.interpolation_enabled:
						var current_value: Variant = node.get(property)
						current_value = lerp(current_value, synced_value, synced_base.interpolation_speed * delta)
						node.set(property, current_value)


#endregion

#region SEND_AND_RECIEVE

func send_property_to_peer_synced_data(node: Node, property: String, value: Variant = null, peer: int = SD_MultiplayerSingleton.HOST_ID, reliable: bool = false) -> void:
	if not SD_Multiplayer.is_active():
		return
	
	if value == null:
		value = node.get(property)
	
	var packet: Dictionary = SD_Multiplayer.get_singleton().serialize_var_into_packet(node, property)
	var serialized_value: Variant = SD_MPDataCompressor.serialize_data(packet)
	
	SD_Multiplayer.request_node_existence(node, _node_exists_recieve, [property, serialized_value, peer], peer, reliable)
	property_sent.emit(node, property, value, peer)

func _node_exists_recieve(result: SD_MPRecievedNodeExistence) -> void:
	if result.exists:
		var property: String = result.args[0]
		var serialized_value: Variant = result.args[1]
		var peer: int = result.args[2]
		
		var node: Node = get_node_or_null(result.node_path)
		
		if result.reliable:
			_recieve_property_to_synced_data_reliable.rpc_id(peer, get_path_to(node), property, serialized_value)
		else:
			_recieve_property_to_synced_data.rpc_id(peer, get_path_to(node), property, serialized_value)

func _recieve_property_to_synced_data_local(node_path: String, property: String, ser_value: Variant, sender: int) -> void:
	var deserialized_packet: Dictionary = SD_MPDataCompressor.deserialize_data(ser_value)
	var deserialized_value: Variant = SD_Multiplayer.get_singleton().deserialize_var_from_packet(deserialized_packet)
	var node: Node = get_node_or_null(node_path)
	if node:
		set_synced_data_property(node, property, deserialized_value)
		for synced_base in get_synced_base(node):
			if synced_base:
				if synced_base is SD_MPPSSyncedProperty:
					if synced_base.properties.has(property):
						if synced_base.interpolation_enabled:
							_interpolate(get_process_delta_time())
						else:
							node.set(property, deserialized_value)
						
						if SD_Multiplayer.is_active():
							property_recieved.emit(node, property, deserialized_value, sender)

@rpc("any_peer", "reliable")
func _recieve_property_to_synced_data_reliable(node_path: String, property: String, ser_value: Variant) -> void:
	_recieve_property_to_synced_data_local(node_path, property, ser_value, multiplayer.get_remote_sender_id())
	
@rpc("any_peer", "unreliable")
func _recieve_property_to_synced_data(node_path: String, property: String, ser_value: Variant) -> void:
	_recieve_property_to_synced_data_local(node_path, property, ser_value, multiplayer.get_remote_sender_id())

#endregion
