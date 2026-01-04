@tool
extends Resource
class_name SD_PluginViewSettings

const _BUILTIN_TABS: Array[PackedScene] = [
	preload("res://addons/simusdev/editor/localization_editor/localization_editor.tscn")
]

signal on_custom_tabs_changed()

@export var custom_tabs: Array[PackedScene] = [] : set = set_custom_tabs

func set_custom_tabs(tabs: Array[PackedScene]) -> void:
	custom_tabs = tabs
	on_custom_tabs_changed.emit()
