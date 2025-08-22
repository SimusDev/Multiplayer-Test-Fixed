@static_unload
extends SD_Object
class_name SD_ConsoleCategories

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

static var CATEGORY_STRING: Dictionary[int, String] = {
	CATEGORY.DEFAULT: "",
	CATEGORY.ERROR: "error",
	CATEGORY.SUCCESS: "success",
	CATEGORY.INFO: "info",
	CATEGORY.WARNING: "warning",
	CATEGORY.EVENTS: "events",
}

static var CATEGORY_COLOR: Dictionary[int, Color] = {
	CATEGORY.DEFAULT: Color(1, 1, 1, 1),
	CATEGORY.ERROR: Color(1, 0.2, 0.2, 1),
	CATEGORY.SUCCESS: Color(0.2, 1.0, 0.2, 1),
	CATEGORY.INFO: Color(0.9, 1.0, 0.9, 1),
	CATEGORY.WARNING: Color(0.97, 0.97, 0, 1.0),
	CATEGORY.EVENTS: Color(1, 0.686, 0.531),
}

static var RICH_COLOR: Dictionary[int, String] = {
	CATEGORY.DEFAULT: "[color=white]%s[/color]",
	CATEGORY.ERROR : "[color=#ff3333]%s[/color]",
	CATEGORY.SUCCESS : "[color=#33ff33]%s[/color]",
	CATEGORY.INFO : "[color=#e6ffe6]%s[/color]",
	CATEGORY.WARNING : "[color=#f7f700]%s[/color]",
	CATEGORY.EVENTS : "[color=#ffaf87]%s[/color]",
}

static func get_category_color(category_id: int) -> Color:
	return CATEGORY_COLOR.get(category_id, Color(1, 1, 1, 1))

static func get_category_as_string(category_id: int) -> String:
	return CATEGORY_STRING[category_id]
