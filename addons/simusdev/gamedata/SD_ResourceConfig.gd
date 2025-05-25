extends Resource
class_name SD_ResourceConfig

@export var _data := {}

func has_section(section: String) -> bool:
	return _data.has(section)

func get_section_data(section: String) -> Dictionary:
	return _data.get(section, {})

func get_section_key_data(section: String, key: String, default = null) -> Variant:
	return get_section_data(section).get(key, default)

func has_section_key(section: String, key: String) -> bool:
	return get_section_data(section).has(key)

func set_variable(section: String, key: String, value: Variant) -> void:
	if not has_section(section):
		_data[section] = {}
	
	var section_data: Dictionary = get_section_data(section)
	section_data[key] = value

func get_variable(section: String, key: String, default = null) -> Variant:
	return get_section_key_data(section, key, default)
