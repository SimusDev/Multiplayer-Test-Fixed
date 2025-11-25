extends SD_NetSync
class_name SD_NetSyncProperties

#@export var channel_override: String = ""
@export var _list: Array[SD_NetSyncedProperty] = []

var _synchronizer: SD_NetSynchronizer

func get_list() -> Array[SD_NetSyncedProperty]:
	return _list

func _ready() -> void:
	for p in _list:
		
		for property in p.properties:
			var node: Node = _synchronizer.get_node_or_null(p.node_path)
			SD_Network.register_object(node)
			SD_Network.register_variable(node, property, {"apply_changes": false})
		
		synchronize(p, true)

func _process(delta: float) -> void:
	for p in _list:
		if p.tickrate_mode == p.TICKRATE_MODE.IDLE:
			_update(p, delta)
		
		_interpolate(p, delta)

func _physics_process(delta: float) -> void:
	for p in _list:
		if p.tickrate_mode == p.TICKRATE_MODE.PHYSICS:
			_update(p, delta)
			#_interpolate(p, delta)

func synchronize(property: SD_NetSyncedProperty, at_start: bool = false) -> void:
	if at_start and not SD_Network.is_server():
		_synchronizer.recieve_property_from(SD_Network.SERVER_ID, property)
		return
	
	if property.sync == property.SYNC.AUTHORITY:
		if _synchronizer.get_multiplayer_authority() == SD_Network.get_unique_id():
			_synchronizer.send_property(property)
			
		else:
			_synchronizer.recieve_property_from(_synchronizer.get_multiplayer_authority(), property)
		return
	
	_synchronizer.send_property(property)
	

func _hook_on_change(property: SD_NetSyncedProperty, delta: float) -> void:
	var node: Node = _synchronizer.get_node(property.node_path)
	var synced: Dictionary[String, Variant] = _synchronizer.get_synced_data(node)
	var hookchange: Dictionary[String, Variant] = _synchronizer.get_hookchange_data(node)
	
	for p_name in property.properties:
		var hook_value: Variant = hookchange.get_or_add(p_name, node.get(p_name))
		var synced_value: Variant = synced.get(p_name, node.get(p_name))
		if node.get(p_name) != hook_value:
			synchronize(property)
			hookchange.set(p_name, node.get(p_name))
	

func _update(property: SD_NetSyncedProperty, delta: float) -> void:
	var property_id: int = _list.find(property)
	var tick: float = _synchronizer.get_tickrate_data().get_or_add(property_id, property.get_tickrate_in_seconds()) as float
	
	var from_server: bool = property.sync == property.SYNC.FROM_SERVER
	
	if _synchronizer.get_multiplayer_authority() == SD_Network.singleton.SERVER_ID:
		from_server = true
	
	if from_server and (not SD_Network.is_server()):
		return
	
	if tick >= property.get_tickrate_in_seconds() or property.tickrate == 0.0:
		
		if property.sync_mode == property.SYNC_MODE.ON_CHANGE:
			_hook_on_change(property, delta)
		else:
			synchronize(property)
			
		_synchronizer.get_tickrate_data().set(property_id, 0.0)
	else:
		_synchronizer.get_tickrate_data().set(property_id, tick + delta)

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

var INTERPOLATING_PROPERTY_METHODS: Dictionary[String, Callable] = {
	"rotation" : _interpolate_rotation
}

func _interpolate_rotation(rotation: Variant, to: Variant, delta: float) -> Variant:
	rotation.x = lerp_angle(rotation.x, to.x, delta)
	rotation.y = lerp_angle(rotation.y, to.y, delta)
	
	if rotation is Vector3:
		rotation.z = lerp_angle(rotation.z, to.z, delta)
	
	return rotation

func _interpolate(property: SD_NetSyncedProperty, delta: float) -> void:
	if not property.interpolation_enabled:
		return
	
	var node: Node = _synchronizer.get_node(property.node_path)
	var synced: Dictionary[String, Variant] = _synchronizer.get_synced_data(node)
	
	for p_name in synced:
		var synced_value: Variant = synced[p_name]
		if INTERPOLATING_VARTYPES.has(typeof(synced_value)):
			var node_value: Variant = node.get(p_name)
			
			var lerp_speed: float = property.interpolation_speed * delta
			#lerp_speed *= 0.8
			#print(lerp_speed)
			
			if p_name in INTERPOLATING_PROPERTY_METHODS:
				var callable: Callable = INTERPOLATING_PROPERTY_METHODS[p_name]
				node_value = callable.call(node_value, synced_value, lerp_speed) 
			else:
				node_value = lerp(node_value, synced_value, lerp_speed)
			
			node.set(p_name, node_value)
	
