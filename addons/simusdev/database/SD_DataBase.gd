extends SD_Config
class_name SD_DataBase

func _init() -> void:
	super()

func add_data(section: String, key: String, value) -> void:
	if has_section_key(section, key):
		return
	set_data(section, key, value)

func set_data(section: String, key: String, value) -> void:
	set_value(section, key, value)

func get_data(section: String, key: String, default = null):
	return get_value(section, key, default)

func has_data(section: String, key: String) -> bool:
	return has_section_key(section, key)

func clear_section(section: String) -> void:
	for key in get_section_keys(section):
		var key_value = get_value(section, key)
		if key_value is Node:
			key_value.queue_free()
	erase_section(section)
