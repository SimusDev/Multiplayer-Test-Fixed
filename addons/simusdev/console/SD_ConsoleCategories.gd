@static_unload
@tool

extends SD_Object
class_name SD_ConsoleCategories

static var on_category_registered := SD_Signal.new("consolecategories.on_category_registered")
static var on_category_unregistered := SD_Signal.new("consolecategories.on_category_unregistered")

static var on_category_output_status_changed := SD_Signal.new("consolecategories.on_category_output_changed")

enum CATEGORY {
	DEFAULT,
	ERROR,
	SUCCESS,
	INFO,
	WARNING,
	EVENTS,
}

const DEFAULT: int = CATEGORY.DEFAULT
const ERROR: int = CATEGORY.ERROR
const SUCCESS: int = CATEGORY.SUCCESS
const INFO: int = CATEGORY.INFO
const WARNING: int = CATEGORY.WARNING
const EVENTS: int = CATEGORY.EVENTS

const STRING_DEFUALT: String = "message"
const STRING_ERROR: String = "error"
const STRING_SUCCESS: String = "success"
const STRING_INFO: String = "info"
const STRING_WARNING: String = "warning"
const STRING_EVENTS: String = "events"

static var CATEGORY_STRING: Dictionary[int, String] = {
	CATEGORY.DEFAULT: STRING_DEFUALT,
	CATEGORY.ERROR: STRING_ERROR,
	CATEGORY.SUCCESS: STRING_SUCCESS,
	CATEGORY.INFO: STRING_INFO,
	CATEGORY.WARNING: STRING_WARNING,
	CATEGORY.EVENTS: STRING_EVENTS,
}

static var CATEGORY_ID: Dictionary[String, int] = {
	STRING_DEFUALT: CATEGORY.DEFAULT,
	STRING_ERROR: CATEGORY.ERROR,
	STRING_SUCCESS: CATEGORY.SUCCESS,
	STRING_INFO: CATEGORY.INFO,
	STRING_WARNING: CATEGORY.WARNING,
	STRING_EVENTS: CATEGORY.EVENTS,
}

static var CATEGORY_COLOR: Dictionary[int, Color] = {
	CATEGORY.DEFAULT: Color(1, 1, 1, 1),
	CATEGORY.ERROR: Color(1, 0.2, 0.2, 1),
	CATEGORY.SUCCESS: Color(0.2, 1.0, 0.2, 1),
	CATEGORY.INFO: Color(0.9, 1.0, 0.9, 1),
	CATEGORY.WARNING: Color(0.97, 0.97, 0, 1.0),
	CATEGORY.EVENTS: Color(1, 0.686, 0.531),
}

static var _cmds: Dictionary[int, SD_ConsoleCommand] = {}

static func _register_builtin() -> void:
	for id in CATEGORY_STRING:
		is_output_enabled_for(id)

static func get_output_cmd(category_id: int) -> SD_ConsoleCommand:
	if !CATEGORY_STRING.has(category_id):
		return null
	
	var string_name: String = CATEGORY_STRING.get(category_id)
	var cmd: SD_ConsoleCommand = _cmds.get(category_id)
	if !cmd:
		cmd = SD_ConsoleCommand.get_or_create("console.category.output." + string_name, true)
	return cmd

static func is_output_enabled_for(category_id: int) -> bool:
	var cmd: SD_ConsoleCommand = get_output_cmd(category_id)
	if cmd:
		return cmd.get_value_as_bool()
	return false

static func set_output_enabled(category_id: int, enabled: bool) -> void:
	var cmd: SD_ConsoleCommand = get_output_cmd(category_id)
	if cmd:
		cmd.set_value(enabled)
		on_category_output_status_changed.invoke(category_id, enabled)

static func register_category(string_name: String, color: Color = Color.WHITE) -> int:
	if CATEGORY_ID.has(string_name):
		return CATEGORY_ID.get(string_name)
	
	var id: int = CATEGORY_ID.size() - 1
	CATEGORY_ID[string_name] = id
	CATEGORY_STRING[id] = string_name
	CATEGORY_COLOR[id] = color
	
	on_category_registered.invoke(id)
	
	return id

static func unregister_category(string_name: String) -> void:
	if !CATEGORY_ID.has(string_name):
		return
	
	var id: int = CATEGORY_ID.get(string_name)
	on_category_unregistered.invoke(id)
	CATEGORY_ID.erase(string_name)
	CATEGORY_STRING.erase(id)
	CATEGORY_COLOR.erase(id)
	

static func has_category(string_name: String) -> bool:
	return CATEGORY_ID.has(string_name)

static func has_category_id(id: int) -> bool:
	return CATEGORY_STRING.has(id)

static func get_category_color(category_id: int) -> Color:
	return CATEGORY_COLOR.get(category_id, Color(1, 1, 1, 1))

static func get_category_as_string(category_id: int) -> String:
	return CATEGORY_STRING[category_id]

static func get_category_id(category_string: String) -> int:
	return CATEGORY_ID.get(category_string, 0)

static func get_category_id_list() -> Array[int]:
	return CATEGORY_STRING.keys()

static func get_category_list() -> Array[String]:
	return CATEGORY_ID.keys()
