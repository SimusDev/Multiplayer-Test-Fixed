extends Node3D
class_name SourceSpawnPoint

@export var spawn_point_name:String = "" ##надо сделать

static var _list: Dictionary[String, SourceSpawnPoint] = {}

static func get_list() -> Array[SourceSpawnPoint]:
	return _list.values()

static func get_by_name(spawn_name: String) -> SourceSpawnPoint:
	return _list.get(spawn_name)

func _enter_tree() -> void:
	if not SD_Network.is_server():
		queue_free()
		return
	
	if _list.has(name):
		name += "_"
	
	_list[name] = self

func _exit_tree() -> void:
	_list.erase(name)

func serialize() -> Dictionary:
	var data: Dictionary = {}
	data.n = name
	data.p = global_position
	data.r = global_rotation
	return data

static func deserialize(from: Dictionary) -> SourceSpawnPointResource:
	var res := SourceSpawnPointResource.new()
	res.global_position = from.p
	res.global_rotation = from.r
	res.name = from.n
	return res
