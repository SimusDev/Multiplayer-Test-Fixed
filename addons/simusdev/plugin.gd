@tool
extends EditorPlugin

var AUTOLOAD := {
	"SimusDev" : "res://addons/simusdev/singletons/s_simusdev.tscn"
}

var editor_plugins: SD_EditorPlugins = null

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	if editor_plugins == null:
		editor_plugins = SD_EditorPlugins.new()
		add_child(editor_plugins)
	
	for s in AUTOLOAD:
		add_autoload_singleton(s, AUTOLOAD[s])

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if editor_plugins:
		remove_child(editor_plugins)
		editor_plugins.queue_free()
		editor_plugins = null
	
	for s in AUTOLOAD:
		remove_autoload_singleton(s)
