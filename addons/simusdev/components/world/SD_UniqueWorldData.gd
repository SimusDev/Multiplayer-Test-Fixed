@icon("res://addons/simusdev/icons/Resource.svg")
extends SD_MPSyncedData
class_name SD_UniqueWorldData

@export var _code: String = ""

static var _instances_by_name: Dictionary[String, SD_UniqueWorldData]
static var _instances_by_code: Dictionary[String, SD_UniqueWorldData]

func _enter_tree() -> void:
	_instances_by_name[name] = self
	_instances_by_code[_code] = self

func _exit_tree() -> void:
	_instances_by_name.erase(name)
	_instances_by_code.erase(_code)

func get_code() -> String:
	return _code

static func get_by_name(_name: String) -> SD_UniqueWorldData:
	return _instances_by_name.get(_name)

static func get_by_code(code: String) -> SD_UniqueWorldData:
	return _instances_by_code.get(code)
