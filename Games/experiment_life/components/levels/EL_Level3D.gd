extends Node3D
class_name EL_Level3D

var _resource: EL_LevelResource

signal initialized()
signal deinitialized()

var _going_to_init: bool = false

const PREFAB_PATH: String = "res://Games/experiment_life/components/levels/EL_Level3D.tscn"

static func instantiate(parent: Node, resource: EL_LevelResource) -> EL_Level3D:
	var scene: PackedScene = load(PREFAB_PATH)
	var level: EL_Level3D = scene.instantiate() as EL_Level3D
	
	level.init(resource)
	parent.add_child(level)
	
	return level

func _enter_tree() -> void:
	name = _resource.name.validate_node_name()
	
	await ready
	_initialized()
	initialized.emit()


func get_resource() -> EL_LevelResource:
	return _resource

func init(resource: EL_LevelResource) -> void:
	_resource = resource
	_going_to_init = true

func _initialized() -> void:
	pass

func deinit() -> void:
	queue_free()

func _exit_tree() -> void:
	deinitialized.emit()
