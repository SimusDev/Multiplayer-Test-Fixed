@tool
extends SD_Object
class_name SD_FileExtensions

const P_IMPORT_DEFAULT := ".import"

const EC_CONFIG := "config"
const EC_INI := "ini"
const EC_DATABASE := "database"
const EC_OBJECT := "object"
const EC_SCENE := "scene"
const EC_SAVE := "save"
const EC_LOCALIZATION := "localization"
const EC_SCRIPT := "script"
const EC_TEXTURE := "texture"
const EC_RESOURCE := "resource"
const EC_RESOURCE_PACK := "resource_pack"
const EC_AUDIO := "audio"

const EXTENSIONS_CODES := {
	EC_CONFIG:
		["secfg", "scfg", "ini", "config", "cfg", "userdata"],
	EC_INI:
		["ini"],
	EC_DATABASE:
		["sdb"],
	EC_OBJECT:
		["object", "obj", "pack", "packed", "prefab"],
	EC_SCENE:
		["tscn", "scn", "res"],
	EC_SCRIPT:
		["script", "gd"],
	EC_SAVE:
		["save", "sav"],
	EC_LOCALIZATION:
		["loc", "ini", "cfg", "txt"],
	EC_TEXTURE:
		["png", "jpg", "dds"],
	EC_RESOURCE:
		["tres", "res"],
	EC_RESOURCE_PACK:
		["zip", "pck"],
	EC_AUDIO:
		["ogg", "mp3", "wav"],
	
	
}

const EXTENSIONS_CODES_IMPORT := {
	EC_SCENE : ".remap",
	EC_SCRIPT : ".remap",
	EC_RESOURCE : ".remap",
}


static func has_extension_code(code: String) -> bool:
	return EXTENSIONS_CODES.has(code)

static func get_extensions_from_code(code: String) -> Array:
	return EXTENSIONS_CODES.get(code, [])

static func get_base_extension_from_code(code: String) -> String:
	var extensions := get_extensions_from_code(code)
	return SD_Array.get_value_from_array(extensions, 0, "")

static func get_extension_code_from_path(path: String) -> String:
	for extension_code in EXTENSIONS_CODES:
		var extensions_array := get_extensions_from_code(extension_code)
		if path.get_extension() in extensions_array:
			return extension_code
	return ""

static func get_extension_code_import_prefix(extension_code: String) -> String:
	return EXTENSIONS_CODES_IMPORT.get(extension_code, P_IMPORT_DEFAULT)

static func is_path_has_any_extension_code(path: String) -> bool:
	return !get_extension_code_from_path(path).is_empty()

static func is_path_ends_with_import_prefix(path: String, extension_code: String) -> bool:
	return path.ends_with(get_extension_code_import_prefix(extension_code))

static func has_extension_in_extension_code(extension: String, extension_code: String) -> bool:
	if has_extension_code(extension_code):
		return get_extensions_from_code(extension_code).has(extension)
	return false

static func remove_import_prefix_from_path(path: String, extension_code: String) -> String:
	if is_path_ends_with_import_prefix(path, extension_code):
		return path.replace(get_extension_code_import_prefix(extension_code), "")
	return path

static func remove_extension_from_path(path: String) -> String:
	if path.get_extension() == "":
		return path
	return path.replacen("." + path.get_extension(), "")

static func plus_file(base_path: String, plus_path: String, extension_code: String) -> String:
	if not has_extension_code(extension_code):
		return ""
	
	var p: String = base_path.path_join(plus_path)
	return plus_extension(p, extension_code)

static func plus_extension(path: String, extension_code: String) -> String:
	if not has_extension_code(extension_code):
		return ""
	
	return path + "." + get_base_extension_from_code(extension_code)
