extends SD_Object
class_name SD_ConsoleMessage

var message
var category: int = 0
var color: Color = Color(1, 1, 1, 1) : set = set_color

signal on_color_changed()

func set_color(new: Color) -> SD_ConsoleMessage:
	color = new
	on_color_changed.emit()
	return self

func get_as_string() -> String:
	return "[%s] %s" % [SD_ConsoleCategories.get_category_as_string(category), str(message)]
