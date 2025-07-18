extends SD_MPSynchronizer
class_name SD_MPPropertySynchronizer

#region VARIABLES

@export var properties: Array[SD_MPPSSyncedBase]

var _singleton: SD_MultiplayerSingleton

var _synced_bases: Dictionary[Node, Array] = {}

@export var auto_set_multiplayer_authority: bool = true


func get_synced_data_property(node: Node, property: String, default_value: Variant = null) -> Variant:
	var properties: Dictionary[String, Variant] = get_synced_data_properties(node)
	return properties.get(property, default_value)

func get_synced_data_properties(node: Node) -> Dictionary[String, Variant]:
	if node.has_meta("mp_synced_data"):
		return node.get_meta("mp_synced_data") as Dictionary[String, Variant]
	
	var data: Dictionary[String, Variant] = {}
	node.set_meta("mp_synced_data", data)
	return data

func get_synced_bases(node: Node) -> Array[SD_MPPSSyncedBase]:
	if not _synced_bases.has(node):
		_synced_bases[node] = [] as Array[SD_MPPSSyncedBase]
	return _synced_bases.get(node)

#endregion


#region SIGNALS
signal property_recieved(node: Node, property: String, value: Variant, from_peer: int)
signal property_sent(node: Node, property: String, value: Variant, to_peer: int)

#endregion


func _ready() -> void:
	_singleton = SD_MultiplayerSingleton.get_instance()
	if not is_instance_valid(_singleton):
		SimusDev.console.write_from_object(self, "initialization failed! can't find SD_MultiplayerSingleton instance!", SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	
	for mp_property in properties:
		init_property(mp_property)
	
	#process_mode = Node.PROCESS_MODE_ALWAYS
	
	set_multiplayer_authority(get_parent().get_multiplayer_authority())
	

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
				synchronize(mp_property, true)

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
	
	

func synchronize(mp_property: SD_MPPSSyncedBase, at_start: bool = false) -> void:
	var node: Node = get_node_or_null(mp_property.node_path)
	if not node:
		return
	
	if mp_property is SD_MPPSSyncedProperty:
		
		if mp_property.sync == mp_property.SYNC.FROM_SERVER:
			if at_start and SD_Multiplayer.is_not_server():
				recieve_properties_from_peer(node, mp_property.properties, SD_Multiplayer.SERVER_ID, mp_property.callmode)
				return
			
			elif SD_Multiplayer.is_server():
				for peer in SD_Multiplayer.get_connected_peers():
					if peer == SD_Multiplayer.get_unique_id():
						continue
					
					
					send_properties_to_peer(node, mp_property.properties, peer, mp_property.callmode)
				return
		
		if is_multiplayer_authority():
			for peer in SD_Multiplayer.get_connected_peers():
				if peer == SD_Multiplayer.get_unique_id():
					continue
				
				send_properties_to_peer(node, mp_property.properties, peer, mp_property.callmode)
		else:
			recieve_properties_from_peer(node, mp_property.properties, node.get_multiplayer_authority(), mp_property.callmode)


#region REFRESHING

func _hook_sync(property: SD_MPPSSyncedBase, delta: float) -> void:
	var node: Node = get_node(property.node_path)
	if !node:
		return
	
	if (node.is_multiplayer_authority() and property.sync == property.SYNC.AUTHORITY) or (SD_Multiplayer.is_server() and property.sync == property.SYNC.FROM_SERVER):
		_refresh(property, delta)
		return
	
	
	_interpolate(property, delta)

func _process(delta: float) -> void:
	for mp in properties:
		if mp.tickrate_mode == mp.TICKRATE_MODE.IDLE:
			_hook_sync(mp, delta)

func _physics_process(delta: float) -> void:
	for mp in properties:
		if mp.tickrate_mode == mp.TICKRATE_MODE.PHYSICS:
			_hook_sync(mp, delta)
	

var _mp_node_properties_hook: Dictionary[SD_MPPSSyncedProperty, Dictionary] = {}
func _hook_property_node_property_change(mp_property: SD_MPPSSyncedProperty, delta: float) -> void:
	var node: Node = get_node_or_null(mp_property.node_path)
	var properties: Dictionary = _mp_node_properties_hook.get_or_add(mp_property, {}) as Dictionary
	for property in mp_property.properties:
		var property_value: Variant = properties.get_or_add(property, node.get(property))
		
		var node_value: Variant = node.get(property)
		
		if property_value != node_value:
			synchronize(mp_property)
			properties.set(property, node_value)
			

var _mp_properties_cooldown: Dictionary[SD_MPPSSyncedProperty, float] = {}

func _refresh(mp_property: SD_MPPSSyncedProperty, delta: float) -> void:
	var current_cooldown: float = _mp_properties_cooldown.get_or_add(mp_property, 0.0)
	current_cooldown = move_toward(current_cooldown, 0.0, delta)
	_mp_properties_cooldown.set(mp_property, current_cooldown)
	
	if current_cooldown <= 0.0:
		current_cooldown = mp_property.get_tickrate_in_seconds()
		
		_mp_properties_cooldown.set(mp_property, current_cooldown)
		
		if mp_property.sync_mode == mp_property.SYNC_MODE.ALWAYS:
			synchronize(mp_property)
		else:
			_hook_property_node_property_change(mp_property, delta)
		
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

func _interpolate(base: SD_MPPSSyncedBase, delta: float) -> void:
	if base is SD_MPPSSyncedProperty:
		var node: Node = get_node_or_null(base.node_path)
		for property in base.properties:
			var synced_properties: Dictionary = get_synced_data_properties(node)
			
			if synced_properties.has(property):
				var current_value: Variant = node.get(property)
				if INTERPOLATING_VARTYPES.has(typeof(current_value)):
					var synced_value: Variant = get_synced_data_property(node, property)
					if base.interpolation_enabled:
						if property == "rotation":
							current_value.x = lerp_angle(current_value.x, synced_value.x, base.interpolation_speed * delta)
							current_value.y = lerp_angle(current_value.y, synced_value.y, base.interpolation_speed * delta)
							
							if current_value is Vector3:
								current_value.z = lerp_angle(current_value.z, synced_value.z, base.interpolation_speed * delta)
						else:
							current_value = lerp(current_value, synced_value, base.interpolation_speed * delta)
						node.set(property, current_value)
#endregion

#region SEND_AND_RECIEVE

func send_properties_to_peer(node: Node, properties: Array, peer: int = SD_MultiplayerSingleton.HOST_ID, callmode: SD_Multiplayer.CALLMODE = SD_Multiplayer.CALLMODE.UNRELIABLE) -> void:
	if not SD_Multiplayer.is_active():
		return
	
	var node_path: NodePath = get_path_to(node)
	
	var synced: Dictionary = {}
	for property in properties:
		synced[property] = node.get(property)
		property_sent.emit(property, node.get(property))
	
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_properties_from_peer_rpc_recieve, [node_path, synced, SD_Multiplayer.get_unique_id()], callmode)
	

func recieve_properties_from_peer(node: Node, properties: Array, peer: int = SD_MultiplayerSingleton.HOST_ID, callmode: SD_Multiplayer.CALLMODE = SD_Multiplayer.CALLMODE.UNRELIABLE) -> void:
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_property_from_peer_rpc_sender, [get_path_to(node), properties, SD_Multiplayer.get_unique_id(), callmode], callmode)

func _recieve_property_from_peer_rpc_sender(path: NodePath, properties: Array, to_peer: int, callmode: SD_Multiplayer.CALLMODE) -> void:
	var node: Node = get_node(path)
	if !node:
		return
	
	var synced: Dictionary = {}
	for property in properties:
		synced[property] = node.get(property)
		
	SD_Multiplayer.sync_call_function_on_peer(to_peer, self, _recieve_properties_from_peer_rpc_recieve, [path, synced, SD_Multiplayer.get_unique_id()], callmode)

func _recieve_properties_from_peer_rpc_recieve(path: NodePath, synced: Dictionary, from_peer: int) -> void:
	var node: Node = get_node_or_null(path)
	for property: String in synced:
		var value: Variant = synced[property]
		get_synced_data_properties(node)[property] = value
		property_recieved.emit(node, property, value, from_peer)
		
		for base in get_synced_bases(node):
			if base is SD_MPPSSyncedProperty:
				if base.properties.has(property):
					
					if !node.has_meta("synced_at_start"):
						node.set_meta("synced_at_start", {})
					
					var dict: Dictionary = node.get_meta("synced_at_start", {}) as Dictionary
					
					if not dict.has(property):
						node.set(property, value)
						dict[property] = value
					
					if not base.interpolation_enabled:
						node.set(property, value)
		
