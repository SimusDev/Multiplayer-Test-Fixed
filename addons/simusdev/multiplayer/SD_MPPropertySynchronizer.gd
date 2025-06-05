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
	
	_synced_data[node] = properties
	

func get_synced_data_property(node: Node, property: String, default_value: Variant = null) -> Variant:
	var properties: Dictionary = get_synced_data_properties(node)
	return properties.get(property, default_value)
	

func get_synced_data_properties(node: Node) -> Dictionary:
	if not _synced_data.has(node):
		_synced_data.set(node, {})
	
	var properties: Dictionary = _synced_data.get(node) as Dictionary
	return properties
	
func get_synced_bases(node: Node) -> Array[SD_MPPSSyncedBase]:
	if not _synced_bases.has(node):
		_synced_bases[node] = [] as Array[SD_MPPSSyncedBase]
	return _synced_bases.get(node)

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
		init_property(mp_property)


var _initialized_properties: Array[SD_MPPSSyncedBase] = []
func init_property(mp_property: SD_MPPSSyncedBase) -> void:
	if not _initialized_properties.has(mp_property):
		_initialized_properties.append(mp_property)
		
		if not properties.has(mp_property):
			properties.append(mp_property)
		
		var node: Node = get_node(mp_property.node_path)
		if node:
			get_synced_bases(node).append(mp_property)
		if mp_property is SD_MPPSSyncedProperty:
			var hook_properties: Dictionary = _mp_node_properties_hook.get_or_add(mp_property, {}) as Dictionary
			if hook_properties:
				for property in mp_property.properties:
					hook_properties.set(property, node.get(property))
			if mp_property.sync_at_start:
				synchronize(mp_property)

func create_property(node: Node, properties: PackedStringArray) -> SD_MPPSSyncedProperty:
	var path: NodePath = get_path_to(node)
	var property: SD_MPPSSyncedProperty = SD_MPPSSyncedProperty.new()
	property.node_path = path
	for p in properties:
		property.properties.append(p)
	return property

var _existable_nodes: Array[String] = []

func synchronize_all() -> void:
	if not SD_Multiplayer.is_active():
		return
	
	for mp_property in properties:
		synchronize(mp_property)
	
	

func synchronize(mp_property: SD_MPPSSyncedBase) -> void:
	var node: Node = get_node_or_null(mp_property.node_path)
	if not node:
		return
	
	if SD_Multiplayer.is_active():
		match mp_property.mode:
			SD_MPPSSyncedProperty.MODE.FROM_SERVER:
				if not multiplayer.is_server():
					if mp_property is SD_MPPSSyncedProperty:
						for property in mp_property.properties:
							recieve_property_from_peer(node, property, SD_MultiplayerSingleton.HOST_ID, mp_property.reliable)
						
			
			SD_MPPSSyncedProperty.MODE.AUTHORITY:
				if is_multiplayer_authority():
					if mp_property is SD_MPPSSyncedProperty:
						for peer in SD_Multiplayer.get_connected_peers():
							if peer == SD_Multiplayer.get_unique_id():
								continue
							
							for property in mp_property.properties:
								send_property_to_peer(node, property, node.get(property), peer, mp_property.reliable)
				else:
					if mp_property is SD_MPPSSyncedProperty:
						for property in mp_property.properties:
							recieve_property_from_peer(node, property, get_multiplayer_authority(), mp_property.reliable)



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
	for base in properties:
		if base is SD_MPPSSyncedProperty:
			var node: Node = get_node_or_null(base.node_path)
			for property in base.properties:
				var synced_properties: Dictionary = get_synced_data_properties(node)
				if synced_properties.has(property):
					var current_value: Variant = node.get(property)
					if INTERPOLATING_VARTYPES.has(typeof(current_value)):
						var synced_value: Variant = get_synced_data_property(node, property)
						if base.interpolation_enabled:
							current_value = lerp(current_value, synced_value, base.interpolation_speed * delta)
							node.set(property, current_value)
#endregion

#region SEND_AND_RECIEVE

func send_property_to_peer(node: Node, property: String, value: Variant = null, peer: int = SD_MultiplayerSingleton.HOST_ID, reliable: bool = false) -> void:
	if not SD_Multiplayer.is_active():
		return
	
	if value == null:
		value = node.get(property)
	
	
	var node_path: NodePath = get_path_to(node)
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_property_from_peer_rpc_recieve, [node_path, property, value, SD_Multiplayer.get_unique_id()]) 
	
	property_sent.emit(node, property, value, peer)

func recieve_property_from_peer(node: Node, property: String, peer: int = SD_MultiplayerSingleton.HOST_ID, reliable: bool = false) -> void:
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_property_from_peer_rpc_sender, [get_path_to(node), property, SD_Multiplayer.get_unique_id(), reliable], reliable)

func _recieve_property_from_peer_rpc_sender(path: NodePath, property: String, to_peer: int, reliable: bool = false) -> void:
	var node: Node = get_node_or_null(path)
	var sender_value: Variant = node.get(property)
	SD_Multiplayer.sync_call_function_on_peer(to_peer, self, _recieve_property_from_peer_rpc_recieve, [path, property, sender_value, SD_Multiplayer.get_unique_id()], reliable)

func _recieve_property_from_peer_rpc_recieve(path: NodePath, property: String, value: Variant, from_peer: int) -> void:
	var node: Node = get_node_or_null(path)
	set_synced_data_property(node, property, value)
	property_recieved.emit(node, property, value, from_peer)
	
	for base in get_synced_bases(node):
		if base is SD_MPPSSyncedProperty:
			if base.properties.has(property):
				if not base.interpolation_enabled:
					node.set(property, value)
	
