@tool
extends EditorPlugin
class_name _SimusDevPlugin

var AUTOLOAD := {
	"SimusDev" : "res://addons/simusdev/singletons/s_simusdev.tscn"
}

var editor_plugins: SD_EditorPlugins = null

const _view_scene: PackedScene = preload("uid://qyvoef4qc0xg")

var _view: Control

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	if editor_plugins == null:
		editor_plugins = SD_EditorPlugins.new()
		add_child(editor_plugins)
	
	for s in AUTOLOAD:
		add_autoload_singleton(s, AUTOLOAD[s])
	
	await get_tree().create_timer(1, false).timeout
	_view = _view_scene.instantiate()
	EditorInterface.get_editor_main_screen().add_child(_view)
	_view.hide()

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	if editor_plugins:
		remove_child(editor_plugins)
		editor_plugins.queue_free()
		editor_plugins = null
	
	for s in AUTOLOAD:
		remove_autoload_singleton(s)
	
	await get_tree().process_frame
	if is_instance_valid(_view):
		_view.queue_free()

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool):
	_view.visible = visible

func _get_plugin_name() -> String:
	return "SimusDev"

func _get_plugin_icon() -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
