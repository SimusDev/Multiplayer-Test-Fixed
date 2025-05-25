@tool
extends EditorPlugin
class_name SD_EditorPlugins

static func get_path_to_plugin(plugin: String) -> String:
	return "simusdev/editor_plugins/%s/" % [plugin]

func _enter_tree() -> void:
	pass
