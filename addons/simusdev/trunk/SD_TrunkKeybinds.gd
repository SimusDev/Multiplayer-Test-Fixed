extends SD_Trunk
class_name SD_TrunkKeybinds

var _binds_by_code := {}
var _binds_list: Array[SD_Keybind]

func _ready() -> void:
	pass
	#_parse_built_in_binds()

func _parse_built_in_binds() -> void:
	for action in InputMap.get_actions():
		if !action.begins_with("ui_"):
			var events := InputMap.action_get_events(action)
			if !events.is_empty():
				var key: String = SD_InputDispatcher.from_events(events)
				var bind := SD_Keybind.new(action, key, true)
				add_bind(bind)

func get_bind_list() -> Array[SD_Keybind]:
	return _binds_list

func has_bind(bind: SD_Keybind) -> bool:
	return _binds_list.has(bind)

func add_bind(bind: SD_Keybind) -> void:
	if has_bind(bind):
		return
	
	_binds_list.append(bind)
	_binds_by_code[bind.get_code()] = bind

func remove_bind(bind: SD_Keybind) -> void:
	if not has_bind(bind):
		return
	
	bind.deinit()
	_binds_list.erase(bind)
	_binds_by_code.erase(bind.get_code())
	

func change_bind(bind: SD_Keybind, new_key: String) -> void:
	if not has_bind(bind):
		return
	
	bind.set_key(new_key)

func has_bind_by_code(code: String) -> bool:
	return _binds_by_code.has(code)

func get_bind_by_code(code: String) -> SD_Keybind:
	return _binds_by_code.get(code, null)

func remove_bind_by_code(code: String) -> void:
	if not _binds_by_code.has(code):
		return
	
	remove_bind(get_bind_by_code(code))
	
func add_bind_by_code(code: String, key: String) -> SD_Keybind:
	if _binds_by_code.has(code):
		return null
	
	var bind := SD_Keybind.new(code, key)
	add_bind(bind)
	return bind

func change_bind_by_code(code: String, new_key: String) -> SD_Keybind:
	var bind := get_bind_by_code(code)
	if bind:
		bind.set_key(new_key)
	return null

func is_bind_pressed(code: String) -> bool:
	return get_bind_by_code(code).is_pressed()

func is_bind_just_pressed(code: String) -> bool:
	return get_bind_by_code(code).is_just_pressed()

func is_bind_just_released(code: String) -> bool:
	return get_bind_by_code(code).is_just_released()
