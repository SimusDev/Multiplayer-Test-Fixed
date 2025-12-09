extends Node
class_name SD_GameState

static var __instance: SD_GameState

var __resource: SD_GameStateResource

static var _objects: Dictionary[String, Object] = {}

func _ready() -> void:
	__instance = self

static func register_object(object: Object, id: String) -> void:
	if id.is_empty():
		if object is Node:
			id = str(object.get_path())
	
	

static func can_save() -> bool:
	if SD_Network.singleton:
		return SD_Network.is_server()
	return false

static func can_load() -> bool:
	return can_save()

static func save(path: String) -> void:
	if can_save():
		__instance.__save()

static func load(path: String) -> void:
	if can_load():
		__instance.__load()

func __load() -> void:
	pass

func __save() -> void:
	pass
