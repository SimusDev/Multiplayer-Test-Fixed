extends Node
class_name SD_NetworkSynchronizer

@export var _data: SD_NetSyncProperties

func _get_property_id(property: SD_NetSyncedProperty) -> int:
	return _data.get_list().find(property)

func _find_property_by_id(id: int) -> int:
	return _data.get_list().get(id)

func get_synced_vars(node: Node) -> Dictionary[String, Variant]:
	if node.has_meta(".synced.vars."):
		return node.get_meta(".synced.vars.")
	var dict: Dictionary[String, Variant] = {}
	node.set_meta(".synced.vars.", dict)
	return dict

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_functions([
		
	])
	
	set_data(_data)
	

func get_data() -> SD_NetSyncProperties:
	return _data

func set_data(new: SD_NetSyncProperties) -> void:
	if new:
		_data = new.duplicate()
		
		for property in get_data().get_list():
			_init_property(property)
		
		_data._ready()

func _process(delta: float) -> void:
	for i in _data.get_list():
		if i.tickrate_mode == i.TICKRATE_MODE.IDLE:
			_tick_property(i)

func _physics_process(delta: float) -> void:
	for i in _data.get_list():
		if i.tickrate_mode == i.TICKRATE_MODE.PHYSICS:
			_tick_property(i)

func _init_property(reference: SD_NetSyncedProperty) -> void:
	for variable in reference.properties:
		SD_Network.singleton.cache.cache_variable(variable)
	
	for channel in reference.channels:
		SD_Network.register_channel(channel)
	
	_sync_property(reference)

func _tick_property(reference: SD_NetSyncedProperty) -> void:
	pass

func _sync_property(reference: SD_NetSyncedProperty) -> void:
	if SD_Network.is_server() and reference.sync == reference.SYNC.FROM_SERVER:
		return
