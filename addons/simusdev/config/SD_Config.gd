extends SD_Object
class_name SD_Config

var _config := ConfigFile.new()

var autosave := false
var encryption: String = ""
var last_path: String = ""

func _init() -> void:
	pass

func combine_config(cfg: SD_Config) -> void:
	var cfg_sections := get_sections()
	if cfg_sections.is_empty():
		return
	
	for section in cfg_sections:
		var section_keys := get_section_keys(section)
		for key in section_keys:
			var key_value = get_value(section, key)
			set_value(section, key, key_value)


func load_config(path: String) -> void:
	path = SD_FileSystem.normalize_path(path)
	SD_FileSystem.make_directory(path.get_base_dir())
	
	if encryption:
		_config.load_encrypted_pass(path, encryption)
	else:
		_config.load(path)
	
	last_path = path

func save_config(path: String) -> void:
	path = SD_FileSystem.normalize_path(path)
	SD_FileSystem.make_directory(path.get_base_dir())
	
	if encryption:
		_config.save_encrypted_pass(path, encryption)
	else:
		_config.save(path)
	
	last_path = path

func save_config_with_autosave() -> void:
	if autosave:
		save_config_last_path()

func save_config_last_path() -> void:
	if not last_path.is_empty():
		save_config(last_path)

func load_config_last_path() -> void:
	if not last_path.is_empty():
		load_config(last_path)

func clear() -> void:
	_config.clear()

func erase_section(section: String) -> void:
	_config.erase_section(section)
	save_config_with_autosave()

func erase_section_key(section: String, key: String) -> void:
	_config.erase_section_key(section, key)
	save_config_with_autosave()

func get_section_keys(section: String) -> PackedStringArray:
	return _config.get_section_keys(section)

func get_sections() -> PackedStringArray:
	return _config.get_sections()

func get_value(section: String, key: String, default = null):
	return _config.get_value(section, key, default)

func set_value(section: String, key: String, value) -> void:
	_config.set_value(section, key, value)
	save_config_with_autosave()

func has_section(section: String) -> bool:
	return _config.has_section(section)

func has_section_key(section: String, key: String) -> bool:
	return _config.has_section_key(section, key)

func parse(data: String) -> int:
	return _config.parse(data)
