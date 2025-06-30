extends Resource
class_name SD_SettingsAdsSDK

@export var _data: Dictionary[String, Variant] = {}

static var SAVE_PATH: String = SD_EngineSettings.BASE_PATH.path_join("ads")

func init(sdk: SD_AdsSDK, data: Dictionary[String, Variant] = {}) -> void:
	_data = data.duplicate()
	
	_on_initialized()

func _on_initialized() -> void:
	pass

static func save_or_load(script: GDScript, sdk: SD_AdsSDK, data: Dictionary[String, Variant] = {}) -> SD_SettingsAdsSDK:
	SD_FileSystem.make_directory(SAVE_PATH)
	var filepath: String = SAVE_PATH.path_join(sdk.get_code()) + ".tres"
	
	if SD_FileSystem.is_file_exists(filepath):
		return load(filepath)
	
	
	var settings: SD_SettingsAdsSDK = script.new() as SD_SettingsAdsSDK
	settings.init(sdk, data)
	ResourceSaver.save(settings, filepath)
	return settings

func set_value(key: String, value: Variant) -> void:
	_data[key] = value

func has_key(key: String) -> bool:
	return _data.has(key)

func get_value(key: String, default_value: Variant = null) -> Variant:
	return _data.get(key, default_value)
