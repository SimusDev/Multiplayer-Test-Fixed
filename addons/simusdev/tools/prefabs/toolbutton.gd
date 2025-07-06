extends Button

var _tool_path: String

func init(tool_name: String) -> void:
	_tool_path = tool_name
	tool_name = tool_name.replacen(SD_FileSystem.PATH_RES, "")
	$Label.text = tool_name

func _on_pressed() -> void:
	SimusDev.tools.open(_tool_path)
