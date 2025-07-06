@icon("res://addons/simusdev/icons/PackedScene.svg")
extends Node
class_name SD_NodeSceneLoader

@export_file("*tscn") var SCENE_PATH: String = ""
@export var LOAD_AT_START: bool = true
@export var CHANGE_SCENE_AFTER_LOAD: bool = false
@export var USE_SUB_THREADS: bool = false

var _is_loading: bool = false
var _current_path: String = ""

var _loaded_scene: PackedScene

signal loading_finished(packed_scene: PackedScene)
signal loading_progress(progress_percents: float)
signal loading_failed()
signal loading_invalid_resource()

func get_loaded_scene() -> PackedScene:
	return _loaded_scene

func _ready() -> void:
	if LOAD_AT_START:
		try_load_scene()

var _progress: Array = []
func _process(delta: float) -> void:
	if not _is_loading:
		return
	
	var status = ResourceLoader.load_threaded_get_status(_current_path, _progress)
	if status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		loading_invalid_resource.emit()
		_is_loading = false
	if status == ResourceLoader.THREAD_LOAD_FAILED:
		loading_failed.emit()
		_is_loading = false
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		loading_progress.emit(get_loading_percents())
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		_is_loading = false
		var loaded: PackedScene = ResourceLoader.load_threaded_get(_current_path)
		_loaded_scene = loaded
		loading_finished.emit(loaded)
		
		if CHANGE_SCENE_AFTER_LOAD:
			get_tree().change_scene_to_packed(loaded)

func try_load_scene(path: String = SCENE_PATH) -> void:
	if _is_loading:
		return
	
	ResourceLoader.load_threaded_request(path, "", USE_SUB_THREADS)
	_current_path = path
	_is_loading = true

func is_loading() -> bool:
	return _is_loading

func get_loading_status() -> float:
	return SD_Array.get_value_from_array(_progress, 0, 0.0)

func get_loading_percents() -> float:
	return get_loading_status() * 100
