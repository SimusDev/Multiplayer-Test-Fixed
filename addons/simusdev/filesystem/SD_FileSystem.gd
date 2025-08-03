@tool
extends SD_Object
class_name SD_FileSystem

const PATH_RES: String = "res://"
const PATH_USER: String = "user://"
const PATH_RUNTIME: String = "runtime://"

const LOOP_ALL_FILES := 0
const LOOP_ONLY_FILES := 1
const LOOP_ONLY_FOLDERS := 2

static func get_extension_from_path(path: String) -> String:
	var extension: String = ""
	if not path.get_extension().is_empty():
		extension = path.get_extension()
	return extension

static func path_is_file(path: String) -> bool:
	print(get_extension_from_path(path))
	return not get_extension_from_path(path).is_empty()
static func directory_exist(path: String) -> bool:
	return DirAccess.dir_exists_absolute(path)

static func normalize_path(path: String) -> String:
	var result: String = path
	
	if path.begins_with(PATH_RES):
		return result
	
	if path.begins_with(PATH_USER):
		if SD_Platforms.is_windows():
			result = result.replacen(PATH_USER, "")
			
			if not SD_Platforms.is_project_builded():
				return PATH_RES.path_join(result)
			
			var normalized: String = OS.get_executable_path().get_base_dir().path_join(result)
			return normalized
		
	
	if path.begins_with(PATH_RUNTIME):
		result = result.replacen(PATH_RUNTIME, "")
		var normalized: String = OS.get_executable_path().get_base_dir().path_join(result)
		return normalized
	
	
	return result

static func make_directory(path: String) -> void:
	if SD_Platforms.is_project_builded():
		if path.begins_with(PATH_RES):
			return
		
	path = normalize_path(path)
	DirAccess.make_dir_recursive_absolute(path)

static func is_path_is_folder(path: String) -> bool:
	return path.get_extension().is_empty()

static func is_path_is_file(path: String) -> bool:
	return !is_path_is_folder(path)

static func is_file_exists(path: String) -> bool:
	var access = DirAccess.open(path.get_base_dir())
	if access != null:
		var ext_code: String = SD_FileExtensions.get_extension_code_from_path(path)
		if not ext_code.is_empty():
			if SD_Platforms.is_project_builded():
				var prefix: String = SD_FileExtensions.get_extension_code_import_prefix(ext_code)
				if prefix:
					path += prefix
		
		
		
		return access.file_exists(path)
	return false

static func _get_files_from_directory(files: Array, old_path: String, loop_through_folders := false, loop_index := LOOP_ALL_FILES) -> Array:
	var path: String = normalize_path(old_path)
	var dir = DirAccess.open(path)
	if dir == null:
		return files
	
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			var path_and_file: String = dir.get_current_dir().path_join(file)
			var filesystem_ignore := false
			if is_path_is_folder(path_and_file):
				var path_filesystem_ignore := path_and_file.path_join("filesystem_ignore.ini")
				if is_file_exists(path_filesystem_ignore):
					filesystem_ignore = true
			
			if not filesystem_ignore:
				match loop_index:
					LOOP_ALL_FILES:
						files.append(path_and_file)
					LOOP_ONLY_FILES:
						if is_path_is_file(path_and_file):
							files.append(path_and_file)
					LOOP_ONLY_FOLDERS:
						if is_path_is_folder(path_and_file):
							files.append(path_and_file)
				if loop_through_folders:
					if is_path_is_folder(path_and_file):
						_get_files_from_directory(files, path_and_file, loop_through_folders, loop_index)
		
	files.sort()
	dir.list_dir_end()
	return files

static func get_files_from_directory(path: String, loop_through_folders := false, loop_index := LOOP_ALL_FILES) -> Array:
	var files := []
	return _get_files_from_directory(files, path, loop_through_folders, loop_index)

static func get_only_files_from_directory(path: String, loop_through_folders := false) -> Array:
	return get_files_from_directory(path, loop_through_folders, LOOP_ONLY_FILES)

static func get_only_folders_from_directory(path: String, loop_through_folders := false) -> Array:
	return get_files_from_directory(path, loop_through_folders, LOOP_ONLY_FOLDERS)

static func is_path_ends_with_import_prefix(path: String, extension_code: String) -> bool:
	return SD_FileExtensions.is_path_ends_with_import_prefix(path, extension_code)
static func is_extension_file_equals_to_extension_code(path: String, extension_code: String) -> bool:
	return SD_FileExtensions.get_extension_code_from_path(path) == extension_code
static func remove_import_prefix_from_path(path: String, extension_code: String) -> String:
	return SD_FileExtensions.remove_import_prefix_from_path(path, extension_code)

static func get_files_with_extension_from_directory(path: String, extension_code: String, loop_through_folders := false) -> Array:
	var files := get_only_files_from_directory(path, loop_through_folders)
	var files_result := []
	
	if not SD_FileExtensions.has_extension_code(extension_code):
		return []
	
	for file in files:
		var file_path: String = file as String
		
		if SD_FileExtensions.is_path_ends_with_import_prefix(file_path, extension_code):
			file_path = remove_import_prefix_from_path(file_path, extension_code)
		
		var file_extension: String = file_path.get_extension()
		if SD_FileExtensions.has_extension_in_extension_code(file_extension, extension_code):
			SD_Array.append_to_array_no_repeat(files_result, file_path)
	
	return files_result

static func get_all_files_with_extension_from_directory(path: String, extension_code: String) -> Array:
	return get_files_with_extension_from_directory(path, extension_code, true)

static func get_all_files_with_all_extenions_from_directory(path: String, loop_through_folders := true) -> Array:
	var result := []
	for extension_code in SD_FileExtensions.EXTENSIONS_CODES:
		result.append_array(get_files_with_extension_from_directory(path, extension_code, loop_through_folders))
	return result
