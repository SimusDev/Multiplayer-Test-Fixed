@icon("res://addons/simusdev/icons/Resource.svg")
extends Node
class_name SD_NodeResourceLoader

@export var section: String = SD_DBResource.SECTION_RESOURCE
@export var file_time: float = 0.0
@export var use_main_thread: bool = true
@export var load_at_start: bool = true
@export var initial_paths: Array[String] = []

var thread: Thread

signal loading_started()
signal loading_finished()

var console: SD_TrunkConsole = SimusDev.console

func _ready() -> void:
	thread = Thread.new()
	
	if load_at_start:
		if use_main_thread:
			load_resources()
		else:
			thread.start(load_resources)

func _exit_tree() -> void:
	if thread.is_alive():
		thread.wait_to_finish()

func load_resources() -> void:
	if initial_paths.is_empty():
		console.write_from_object(self, "cant load resources because initial paths is empty", SD_ConsoleCategories.CATEGORY.ERROR)
		return
	
	
	call_deferred("emit_signal", "loading_started")
	var files_to_load: Array = []
	for path in initial_paths:
		var files_from_path: Array = SD_FileSystem.get_all_files_with_all_extenions_from_directory(path)
		files_to_load.append_array(files_from_path)
	
	for file in files_to_load:
		var loaded: Variant = load_resource(file)
		if file_time > 0.0:
			await get_tree().create_timer(file_time).timeout
	
	call_deferred("emit_signal", "loading_finished")
	if thread.is_alive():
		thread.wait_to_finish()

func load_resource(path: String, resource_section: String = section) -> Variant:
	var resource: Variant = SD_ResourceLoader.load(path, resource_section)
	return resource
