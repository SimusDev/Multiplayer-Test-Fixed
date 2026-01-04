@tool
@static_unload
extends Resource
class_name SD_EngineSettings

static var _instance: SD_EngineSettings

@export var developer: String = ""
@export var game_code: String = ""

@export_group("$$$")
@export var monetization: Dictionary[String, Variant] = {
	"enabled": true,
	"create_singleton": true,
	"autoselect_sdk": true,
	"pause_when_ad_show": true,
}

@export_group("Game")
@export var game: Dictionary[String, Variant] = {
	"minimize_feature": false,
	"minimize_feature_on_release": true,
	"mute_audio_when_minimized": true,
	"pause_when_minimized": false,
}

@export var gamebuild: SD_GameBuildSettings = SD_GameBuildSettings.new()

@export_group("Console")
@export var console: Dictionary[String, Variant] = {
	"enabled": true,
	"enabled_desktop_override": true,
	"disable_on_release": true,
	"gd_print": true,
	"hide_private_commands": true,
	"size": Vector2(768, 512),
}
@export var commands: SD_ConsoleNodeCommandObjectStorage

@export_group("Audio")
@export var audio: Dictionary[String, Variant] = {
	"bus_volume_min": 0.0,
	"bus_volume_max": 1.0,
}

@export_group("UI")
@export var ui: Dictionary[String, Variant] = {
	"dynamic_size_min": 0.5,
	"dynamic_size_max": 1.0,
}

@export_group("Popups")
@export var popups: Dictionary[String, Variant] = {
	"enabled": true,
	"apply_ui_dynamic_size": true,
	"base_path": "res://popups/%s.tscn",
	"canvas_layer": 16,
	"input": "ui_cancel",
}

@export var popups_default_animations: Array[SD_PopupAnimationResource] = []
@export var popups_container: SD_PopupContainerResource


@export_group("Localization")

@export var localization_flags: Dictionary[String, Texture] = {
	
}

@export var localization_language_unique_name: Dictionary[String, String] = {
	
}

@export var localization_resources: Array[SD_LocalizationResource] = [] : set = set_localization_resources
@export var localization_language: StringName = "en" : set = set_localization_language

func set_localization_resources(new: Array[SD_LocalizationResource]) -> void:
	localization_resources = new
	
	for i in new:
		if i:
			SimusDev.localization.import_from_resource(i)

func set_localization_language(new: StringName) -> void:
	localization_language = new
	SimusDev.localization.update_localization()

@export_group("Tools")
@export var tools: Array[PackedScene] = []
@export var custom_cursor_node: PackedScene

@export_group("Networking")
@export var network: SD_NetworkSettings = SD_NetworkSettings.new()
@export var multiplayer: SD_MultiplayerSettings = SD_MultiplayerSettings.new()

@export_group("Editor")
@export var editor_view: SD_PluginViewSettings = SD_PluginViewSettings.new() : get = get_editor_view

func get_editor_view() -> SD_PluginViewSettings:
	if !editor_view:
		editor_view = SD_PluginViewSettings.new()
		return editor_view
	return editor_view

const BASE_PATH: String = "res://settings"
const FILE_PATH: String = "res://settings/engine.tres"

func _ready() -> void:
	gamebuild._ready()

static func get_base_path() -> String:
	return BASE_PATH

static func create_or_get() -> SD_EngineSettings:
	if _instance:
		return _instance
	
	if SD_FileSystem.is_file_exists(FILE_PATH):
		_instance = load(FILE_PATH) as SD_EngineSettings
		return _instance
	
	SD_FileSystem.make_directory(BASE_PATH)
	var settings: SD_EngineSettings = SD_EngineSettings.new()
	ResourceSaver.save(settings, FILE_PATH)
	_instance = settings
	return _instance
