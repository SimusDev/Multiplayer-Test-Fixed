extends SD_DataBase
class_name SD_DBResource

const SECTION_RESOURCE := "main"

func _ready() -> void:
	pass

func add_resource(key: String, resource, section := SECTION_RESOURCE) -> void:
	add_data(section, key, resource)

func get_resource(key: String, default = null, section := SECTION_RESOURCE):
	return get_data(section, key, default)

func has_resource(key: String, section := SECTION_RESOURCE) -> bool:
	return has_data(section, key)
