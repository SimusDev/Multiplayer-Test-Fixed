extends SD_Object
class_name SD_Binds

static var _keybinds: SD_TrunkKeybinds

func _init(singleton: SD_TrunkKeybinds) -> void:
	_keybinds = singleton

static func has_by_code(code: String) -> bool:
	return _keybinds.has_bind_by_code(code)

static func get_by_code(code: String) -> SD_Keybind:
	return _keybinds.get_bind_by_code(code)

static func remove_by_code(code: String) -> void:
	return _keybinds.remove_bind_by_code(code)

static func add_by_code(code: String, key: String) -> SD_Keybind:
	return _keybinds.add_bind_by_code(code, key)

static func change_by_code(code: String, new_key: String) -> SD_Keybind:
	return _keybinds.change_bind_by_code(code, new_key)

static func is_pressed(code: String) -> bool:
	return _keybinds.is_bind_just_pressed(code)

static func is_just_pressed(code: String) -> bool:
	return _keybinds.is_bind_just_pressed(code)

static func is_just_released(code: String) -> bool:
	return _keybinds.is_bind_just_released(code)
