extends SD_Object
class_name SD_Localization

signal updated()

var _data := ConfigFile.new()

var _current_language: String = DEFAULT_LANGUAGE

var enabled: bool = true

var _flags: Dictionary[String, Texture] = {}
var _unique_names: Dictionary[String, String] = {}

const DEFAULT_LANGUAGE: String = "en"

func update_localization() -> void:
	updated.emit()

func import_from_resource(resource: SD_LocalizationResource) -> void:
	if enabled:
		_data.parse(resource.DATA)
		update_localization()

func set_text_to_key(key: String, text: String, language: String = _current_language) -> void:
	_data.set_value(language, key, text)
	update_localization()

func get_text_from_key(key: String, language: String = _current_language) -> String:
	var text: String = _data.get_value(language, key, key) as String
	return text

func get_current_language() -> String:
	return _current_language

func set_current_languge(language: String) -> void:
	_current_language = language
	update_localization()

func get_available_languages() -> PackedStringArray:
	return _data.get_sections()

func get_flag_texture(language: String) -> Texture:
	return _flags.get(language, null)

func get_flags() -> Dictionary[String, Texture]:
	return _flags

func get_unique_name(language: String) -> String:
	return _unique_names.get(language, "")
