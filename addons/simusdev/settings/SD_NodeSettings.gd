@icon("res://addons/simusdev/icons/Group.svg")
extends Node
class_name SD_NodeSettings

var _base := SD_Settings.new()

@export var config_path: String = "settings.ini"
@export var load_at_start := true

signal on_setting_added(setting_name: String)
signal on_setting_changed(setting_name: String)
signal on_setting_changed_or_added(setting_name: String)
signal on_setting_removed(setting_name: String)

func _ready() -> void:
	_base.on_setting_added.connect(func(): on_setting_added.emit())
	_base.on_setting_changed.connect(func(): on_setting_changed.emit())
	_base.on_setting_changed_or_added.connect(func(): on_setting_changed_or_added.emit())
	_base.on_setting_removed.connect(func(): on_setting_removed.emit())
	
	if load_at_start:
		load_settings_from_path(config_path)

func load_settings_from_path(config_path: String) -> void:
	_base.load_settings_from_path(config_path)

func add_setting(setting: String, value = null) -> void:
	_base.add_setting(setting, value)

func remove_setting(setting: String) -> void:
	_base.remove_setting(setting)

func change_setting(setting: String, value) -> void:
	_base.change_setting(setting, value)

func has_setting(setting: String) -> bool:
	return _base.has_setting(setting)

func add_default_setting(setting: String, value = null) -> void:
	_base.add_default_setting(setting, value)

func remove_default_setting(setting: String) -> void:
	_base.remove_default_setting(setting)

func has_default_setting(setting: String) -> bool:
	return _base.has_default_setting(setting)

func get_default_setting_value(setting: String, default_value = null) -> Variant:
	return _base.get_default_setting_value(setting, default_value)
