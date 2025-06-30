@tool
extends SD_SubViewport
class_name SD_SubViewportScreenShoter

@export_tool_button("ScreenShot") var toolbutton = shot

@export var base_path: String = "res://.viewport"
@export var filename: String = "image"

func shot() -> void:
	SD_FileSystem.make_directory(base_path)
	var path: String = base_path.path_join(filename)
	
	var id: int = 0
	for file: String in SD_FileSystem.get_files_from_directory(base_path):
		if file.get_file().begins_with(filename):
			id += 1
	
	if id > 0:
		path += str(id)
	
	make_screenshot(path)
