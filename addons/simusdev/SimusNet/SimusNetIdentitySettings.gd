extends Resource
class_name SimusNetIdentitySettings

@export var unique_id: Variant : set = set_unique_id, get = get_unique_id

static var __server_id: int = -1

func set_unique_id(id: Variant) -> SimusNetIdentitySettings:
	if id is Object:
		printerr("an ID cannot be an object!")
		print_debug()
		push_error("an ID cannot be an object!")
	
	unique_id = id
	return self

func get_unique_id() -> Variant:
	return unique_id

static func create() -> SimusNetIdentitySettings:
	var settings := SimusNetIdentitySettings.new()
	return settings

static func _generate_instance_int() -> int:
	__server_id += 1
	return __server_id

static func _delete_instance_int() -> void:
	pass
