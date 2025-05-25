extends SD_Object
class_name SD_ResourceLoader

static func get_db() -> SD_DBResource:
	return SimusDev.db_resource
static func get_console() -> SD_Console:
	return SimusDev.console

static func load(path: String, resource_section := get_db().SECTION_RESOURCE) -> Object:
	var loaded_resource: Object = null
	if get_db().has_resource(path):
		#throw_error_resource_already_loaded(path)
		return get_db().get_resource(path)
	
	var path_file_extension: String = path.get_extension()
	if path_file_extension.is_empty():
		#throw_error_load(path)
		return loaded_resource
	
	if path.begins_with(SD_FileSystem.PATH_RES):
		loaded_resource = load(path) 
	elif path.begins_with(SD_FileSystem.PATH_RUNTIME):
		loaded_resource = load_runtime(path)
	else:
		loaded_resource = load_runtime(path)
	
	if loaded_resource == null:
		#throw_error_load(path)
		return loaded_resource
	
	get_db().add_resource(path, loaded_resource, resource_section)
	#throw_info_resource_loaded(path)
	
	if loaded_resource.has_method("_loaded_by_resource_loader"):
		loaded_resource._loaded_by_resource_loader()
	return loaded_resource

static  func clear_section(section: String) -> void:
	get_db().clear_section(section)

static func load_runtime(path: String) -> Object:
	var loaded_resource: Object = null
	
	var path_file_extension: String = path.get_extension()
	if path_file_extension.is_empty():
		return loaded_resource
	
	
	var real_path: String = SD_FileSystem.normalize_path(path)
	
	var dir := DirAccess.open(real_path.get_base_dir())
	
	var file_exists: bool = dir.file_exists(real_path)
	if not file_exists:
		return loaded_resource
	
	var file_extension_code: String = SD_FileExtensions.get_extension_code_from_path(real_path)
	
	
	if file_extension_code.is_empty():
		return loaded_resource
	
	loaded_resource = load_runtime_extension(real_path, file_extension_code)
	
	return loaded_resource

static func load_runtime_extension(path: String, extension_code: String) -> Object:
	var loaded_resource: Object = null
	match extension_code:
		SD_FileExtensions.EC_CONFIG:
			loaded_resource = SD_ImporterConfig.load(path, SD_FileExtensions.EC_CONFIG)
		SD_FileExtensions.EC_INI:
			loaded_resource = SD_ImporterConfig.load(path, SD_FileExtensions.EC_INI)
		SD_FileExtensions.EC_LOCALIZATION:
			loaded_resource = SD_ImporterLocalization.load(path)
		SD_FileExtensions.EC_SCRIPT:
			loaded_resource = SD_ImporterScript.load(path)
		SD_FileExtensions.EC_TEXTURE:
			loaded_resource = SD_ImporterTexture.load(path)
		SD_FileExtensions.EC_OBJECT:
			loaded_resource = SD_ImporterObject.load(path)
		SD_FileExtensions.EC_SCENE:
			loaded_resource = ResourceLoader.load(path)
		SD_FileExtensions.EC_RESOURCE:
			loaded_resource = ResourceLoader.load(path)
		SD_FileExtensions.EC_RESOURCE_PACK:
			loaded_resource = SD_ImporterResourcePack.load(path)
	
	return loaded_resource
