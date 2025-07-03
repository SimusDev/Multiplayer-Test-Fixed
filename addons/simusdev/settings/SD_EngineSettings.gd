extends Resource
class_name SD_EngineSettings

@export var developer: String = ""
@export var game_code: String = ""

@export var monetization: Dictionary[String, Variant] = {
	"enabled": true,
	"create_singleton": true,
	"autoselect_sdk": true,
	"pause_when_ad_show": true,
}

@export var game: Dictionary[String, Variant] = {
	"minimize_feature": false,
	"minimize_feature_on_release": true,
	"mute_audio_when_minimized": true,
	"pause_when_minimized": false,
}

@export var console: Dictionary[String, Variant] = {
	"enabled": true,
	"disable_on_release": true,
	"gd_print": true,
}

@export var audio: Dictionary[String, Variant] = {
	"bus_volume_min": 0.0,
	"bus_volume_max": 1.0,
}

@export var popups: Dictionary[String, Variant] = {
	"base_path": "res://popups/%.tscn",
	"canvas_layer": 16,
}

@export var popups_default_animations: Array[SD_PopupAnimationResource] = []

@export var commands: SD_ConsoleNodeCommandObjectStorage
@export var tools: Array[PackedScene] = []

@export var custom_cursor_node: PackedScene

const BASE_PATH: String = "res://settings"
const FILE_PATH: String = "res://settings/engine.tres"

static func get_base_path() -> String:
	return BASE_PATH

static func create_or_get() -> SD_EngineSettings:
	if SD_FileSystem.is_file_exists(FILE_PATH):
		return load(FILE_PATH) as SD_EngineSettings
	
	SD_FileSystem.make_directory(BASE_PATH)
	var settings: SD_EngineSettings = SD_EngineSettings.new()
	ResourceSaver.save(settings, FILE_PATH)
	return settings
