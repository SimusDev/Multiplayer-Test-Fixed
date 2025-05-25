extends SD_Object
class_name SD_Settings

var _cfg := SD_Config.new()

var BASE_PATH: String = SD_FileSystem.PATH_USER.path_join(".settings/")

var _settings := {}

const SECTION_SETTINGS := "settings"
const SECTION_SETTINGS_DEFAULT := "settings_default"

signal on_setting_added(setting_name: String)
signal on_setting_changed(setting_name: String)
signal on_setting_changed_or_added(setting_name: String)
signal on_setting_removed(setting_name: String)

func load_settings_from_path(path: String) -> void:
	_cfg.autosave = true
	_cfg.load_config(BASE_PATH.path_join(path))
	_cfg.set_value("___settings___", "initialized", true)

func add_setting(setting: String, value = null) -> void:
	if has_setting(setting):
		return
	
	
	if has_default_setting(setting):
		value = get_setting_value(setting, get_default_setting_value(setting))
	
	_settings[setting] = value
	add_default_setting(setting, value)
	_cfg.set_value(SECTION_SETTINGS, setting, value)
	
	on_setting_added.emit(setting)
	on_setting_changed_or_added.emit(setting)

func remove_setting(setting: String) -> void:
	if not has_setting(setting):
		return
	
	_settings.erase(setting)
	remove_default_setting(setting)
	_cfg.erase_section_key(SECTION_SETTINGS, setting)
	
	on_setting_removed.emit(setting)
	

func change_setting(setting: String, value) -> void:
	if not has_setting(setting):
		return
	
	_settings[setting] = value
	
	_cfg.set_value(SECTION_SETTINGS, setting, value)
	on_setting_changed.emit(setting)
	on_setting_changed_or_added.emit(setting)

func has_setting(setting: String) -> bool:
	return _settings.has(setting)

func add_default_setting(setting: String, value = null) -> void:
	if has_default_setting(setting):
		return
	_cfg.set_value(SECTION_SETTINGS_DEFAULT, setting, value)

func remove_default_setting(setting: String) -> void:
	if not has_default_setting(setting):
		return
	_cfg.erase_section_key(SECTION_SETTINGS_DEFAULT, setting)

func has_default_setting(setting: String) -> bool:
	return _cfg.has_section_key(SECTION_SETTINGS_DEFAULT, setting)

func get_default_setting_value(setting: String, default_value = null) -> Variant:
	return _cfg.get_value(SECTION_SETTINGS_DEFAULT, setting, default_value)

func get_setting_value(setting: String, default_value = null) -> Variant:
	return _cfg.get_value(SECTION_SETTINGS, setting, default_value)
