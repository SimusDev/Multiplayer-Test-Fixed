@tool
extends EditorPlugin
class_name SD_EditorPlugins

var _packages: Array[GDScript] = [
	
]

static func get_path_to_plugin(plugin: String) -> String:
	return "simusdev/editor_plugins/%s/" % [plugin]

func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	pass

func register() -> void:
	pass

func unregister() -> void:
	pass
