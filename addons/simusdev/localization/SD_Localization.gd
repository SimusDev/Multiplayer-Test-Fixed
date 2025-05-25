extends SD_Object
class_name SD_Localization

signal updated()

var _data := ConfigFile.new()

var _current_language: String = ""

func update_localization() -> void:
	updated.emit()

func import_from_resource(resource: SD_LocalizationResource) -> void:
	_data.parse(resource.DATA)
	update_localization()

func import_from_file(path: String) -> SD_Config:
	var cfg := SD_Config.new()
	cfg.load_config(path)
	return cfg

func set_text_to_key(key: String, text: String, language: String = _current_language) -> void:
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
