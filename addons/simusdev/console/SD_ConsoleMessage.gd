extends SD_Object
class_name SD_ConsoleMessage

var message
var category: int = 0
var color: Color = Color(1, 1, 1, 1)

func get_as_string() -> String:
	return "[%s] %s" % [SD_ConsoleCategories.get_category_as_string(category), str(message)]
