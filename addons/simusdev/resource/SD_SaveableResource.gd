extends Resource
class_name SD_SaveableResource

@export var storage: Dictionary = {}

func is_server_authorative() -> bool:
	return false

func get_filename() -> String:
	return "resource"

func is_encrypted() -> bool:
	return false

func get_base_path() -> String:
	return "user://data/"

static func get_or_create(script: GDScript = SD_SaveableResource) -> SD_SaveableResource:
	var placeholder: Object = script.new()
	if not placeholder is SD_SaveableResource:
		SD_Console.i().write_from_object(placeholder, "cant get or create saveable resource, script must inherit from SD_SaveableResource!", SD_ConsoleCategories.ERROR)
		return placeholder
	
	if SD_Network.singleton:
		if placeholder.is_server_authorative() and !SD_Network.is_server():
			return placeholder
	
	SD_FileSystem.make_directory(placeholder.get_base_path())
	
	var extension: String = ".tres"
	if placeholder.is_encrypted():
		extension = ".res"
	
	var normalized_path: String = SD_FileSystem.normalize_path(placeholder.get_base_path())
	var file_path: String = normalized_path.path_join(placeholder.get_filename()) + extension
	
	if SD_FileSystem.is_file_exists(file_path):
		return ResourceLoader.load(file_path)
	
	var resource = script.new()
	ResourceSaver.save(resource, file_path)
	return resource
	

func save() -> void:
	var extension: String = ".tres"
	if is_encrypted():
		extension = ".res"
	
	var normalized_path: String = SD_FileSystem.normalize_path(get_base_path())
	var file_path: String = normalized_path.path_join(get_filename()) + extension
	
	ResourceSaver.save(self, file_path)
