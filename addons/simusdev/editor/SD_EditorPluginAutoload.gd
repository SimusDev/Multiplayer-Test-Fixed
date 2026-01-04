@tool
extends EditorPlugin
class_name SD_EditorPluginAutoload

func _ready() -> void:
	SD_AutoLoad.request_editor_plugin_ready(self, _autoload_ready, _autoload_free)

func _autoload_ready() -> void:
	pass

func _autoload_free() -> void:
	pass
