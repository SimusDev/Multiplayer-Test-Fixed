extends Resource
class_name SD_ResourceGameData

const BASE_PATH: String = "user://.gamedata"
const BASE_EXTENSION: String = ".tres"

var _initialized: bool = false
var _config: SD_ResourceConfig

static func get_normalized_path(path: String) -> String:
	return SD_FileSystem.normalize_path(BASE_PATH.path_join(path) + BASE_EXTENSION)

func console_write(text, category: int) -> SD_ConsoleMessage:
	return SimusDev.console.write_from_object(self, text, category)

func initialize(path: String, config: SD_ResourceConfig) -> bool:
	if _initialized:
		return false
	
	_initialized = true
	_config = config
	
	console_write("initialized!", SD_ConsoleCategories.CATEGORY.SUCCESS)
	
	var normalized_path: String = get_normalized_path(path)
	if !ResourceLoader.exists(normalized_path):
		save_config(path)
	
	load_config(path)
	
	return true

func load_config(path: String) -> SD_ResourceConfig:
	if not _initialized:
		return _config
	
	var normalized_path: String = get_normalized_path(path)
	if ResourceLoader.exists(normalized_path):
		_config = ResourceLoader.load(normalized_path) as SD_ResourceConfig
	return _config

func save_config(path: String) -> SD_ResourceConfig:
	if not _initialized:
		return null
	
	var normalized_path: String = get_normalized_path(path)
	SD_FileSystem.make_directory(normalized_path.get_base_dir())
	ResourceSaver.save(_config, normalized_path)
	return _config

func has_section(section: String) -> bool:
	return _config.has_section(section)

func get_section_data(section: String) -> Dictionary:
	return _config.get_section_data(section)

func get_section_key_data(section: String, key: String, default = null) -> Variant:
	return _config.get_section_key_data(section, key, default)

func has_section_key(section: String, key: String) -> bool:
	return _config.has_section_key(section, key)

func set_variable(section: String, key: String, value: Variant) -> void:
	_config.set_variable(section, key, value)

func get_variable(section: String, key: String, default = null) -> Variant:
	return _config.get_variable(section, key, default)

func get_config() -> SD_ResourceConfig:
	return _config
