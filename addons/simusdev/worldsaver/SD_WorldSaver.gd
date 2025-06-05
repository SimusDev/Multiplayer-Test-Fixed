extends SD_Object
class_name SD_WorldSaver

signal load_begin(data: SD_WorldSavedData)
signal loaded(data: SD_WorldSavedData)

signal save_begin(data: SD_WorldSavedData)
signal saved(data: SD_WorldSavedData)

var _data: SD_WorldSavedData = SD_WorldSavedData.new()

const EXTENSTION: String = ".tres"

static func get_base_path() -> String:
	if SD_Platforms.is_pc():
		if SD_Platforms.is_release_build():
			return SD_FileSystem.normalize_path("runtime://.saves")
		else:
			return "res://.saves"
	return "user://"

func get_data() -> SD_WorldSavedData:
	return _data

func load_data(path: String = "save") -> SD_WorldSavedData:
	SD_FileSystem.make_directory(get_base_path())
	var file_path: String = get_base_path().path_join(path) + EXTENSTION
	
	_data._saver = self
	load_begin.emit(_data)
	
	if ResourceLoader.exists(file_path):
		var loaded_resource: SD_WorldSavedData = ResourceLoader.load(file_path)
		if loaded_resource:
			_data = loaded_resource.duplicate()
			_data._saver = self
			loaded.emit(_data)
	
	return _data

func save_data(path: String = "save") -> SD_WorldSavedData:
	SD_FileSystem.make_directory(get_base_path())
	var file_path: String = get_base_path().path_join(path) + EXTENSTION
	
	_data._saver = self
	_data.path = path
	
	save_begin.emit(_data)
	
	ResourceSaver.save(_data, file_path)
	
	saved.emit(_data)
	
	return _data

func save_var(key: String, value: Variant) -> void:
	_data.save_var(key, value)

func load_var(key: String, default_value: Variant = null) -> Variant:
	return _data.load_var(key, default_value)
