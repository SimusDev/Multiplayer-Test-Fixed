extends Resource
class_name SimusNetSettings

@export_group("Time", "time")
@export var time_tickrate: float = 48.0

#@export_group("Connection", "connection")
#@export var connection_max_peers: int = 512

@export_group("Debug", "debug")
@export var debug_enable: bool = true

@export_group("Serialization/Deserialization", "serialization_deserialization")
@export var serialization_deserialization_enable: bool = true

const FILEPATH: String = "res://simusnet.tres"

static var ___ref: SimusNetSettings

static func get_or_create() -> SimusNetSettings:
	if ___ref:
		return ___ref
	var resource: Resource = ResourceLoader.load(FILEPATH)
	if resource:
		___ref = resource
		return resource
	
	resource = SimusNetSettings.new()
	___ref = resource
	ResourceSaver.save(resource, FILEPATH)
	return resource
