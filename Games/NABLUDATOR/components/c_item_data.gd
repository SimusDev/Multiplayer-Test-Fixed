extends Node
class_name C_NabludatorItemData

var _dict: Dictionary = {}

func _ready() -> void:
	SD_Network.register_variables(self, [
		"_dict"
	])
	
	SD_Network.register_functions([
		_n_get_or_add,
		_n_set_value,
	])
	
	SD_Network.var_sync_from_server(self, ["_dict"])

func get_or_add(key: String, default_value: Variant = null) -> Variant:
	if _dict.has(key):
		return get_value(key, default_value)
	
	SD_Network.call_func_except_self(_n_get_or_add, [key, default_value])
	return _n_get_or_add(key, default_value)

func _n_get_or_add(key: String, default_value: Variant = null) -> Variant:
	return _dict.get_or_add(key, default_value)

func set_value(key: String, value: Variant) -> void:
	SD_Network.call_func(_n_set_value, [key, value])

func _n_set_value(key: String, value: Variant) -> void:
	_dict.set(key, value)

func get_value(key: String, default: Variant = null) -> Variant:
	return _dict.get(key, default)
