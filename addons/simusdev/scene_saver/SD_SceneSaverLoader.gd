@icon("res://addons/simusdev/icons/Save.png")
extends Node
class_name SD_SceneSaverLoader

@export var path: String = "user://.saves"
@export var channel: StringName

var extension: String = ".tres"

signal begin_save()
signal saved()
signal begin_load()
signal loaded()

static var _instances: Array[SD_SceneSaverLoader] = []

static func get_instances() -> Array[SD_SceneSaverLoader]:
	return _instances

func _enter_tree() -> void:
	_instances.append(self)

func _exit_tree() -> void:
	_instances.erase(self)

var _data: SD_SceneSavedData = SD_SceneSavedData.new()

func get_data() -> SD_SceneSavedData:
	return _data

func get_or_create_node(path: NodePath) -> SD_SceneSavedNode:
	if path in _data.nodes:
		return _data.nodes.get(path)
	
	var new_data: SD_SceneSavedNode = SD_SceneSavedNode.new()
	_data.nodes[path] = new_data
	return new_data

func move_node_to(from: NodePath, to: NodePath) -> void:
	var current := get_or_create_node(from)
	_data.nodes.erase(from)
	_data.nodes[to] = current

func _ready() -> void:
	pass

func save_scene(file: String) -> void:
	var normalized: String = SD_FileSystem.normalize_path(path)
	SD_FileSystem.make_directory(normalized)
	normalized = normalized.path_join(file) + extension
	
	begin_save.emit()
	ResourceSaver.save(_data, normalized)
	saved.emit()
	

func load_scene(file: String) -> void:
	var normalized: String = SD_FileSystem.normalize_path(path)
	SD_FileSystem.make_directory(normalized)
	normalized = normalized.path_join(file) + extension
	
	begin_load.emit()
	
	if not SD_FileSystem.is_file_exists(normalized):
		save_scene(file)
	
	_data = (ResourceLoader.load(normalized) as SD_SceneSavedData).duplicate()
	loaded.emit()
	
