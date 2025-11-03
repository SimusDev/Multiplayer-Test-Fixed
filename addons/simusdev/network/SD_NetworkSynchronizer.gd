extends Node
class_name SD_NetworkSynchronizer

@export var _data: SD_NetSyncProperties

func _ready() -> void:
	set_data(_data)

func get_data() -> SD_NetSyncProperties:
	return _data

func set_data(new: SD_NetSyncProperties) -> void:
	if new:
		_data = new.duplicate()
		for variable in _data.properties:
			SD_Network.singleton.cache.cache_variable(variable)
		_data._ready()
