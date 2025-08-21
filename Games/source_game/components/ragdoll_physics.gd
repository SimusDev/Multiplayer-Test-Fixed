extends Node
class_name SourceRagdollPhysics

const DELETION_TIME: float = 5.0

@export var _root: Node
@export var _simulator: PhysicalBoneSimulator3D

var _time: float = 0.0

var _networked: bool = false

func _ready() -> void:
	if !_root:
		_root = get_parent()
	
	if _root.get_parent() is SourceLevelSection3D:
		var level: SourceLevelSection3D = _root.get_parent() as SourceLevelSection3D
		_networked = level.networked
	
	set_process(_root is Node3D)
	
	await get_tree().physics_frame
	_simulator.physical_bones_start_simulation()

func _process(delta: float) -> void:
	if (SD_Network.is_server() and _networked) or (!_networked):
		_time = move_toward(_time, DELETION_TIME, delta)
	
	if _time >= DELETION_TIME:
		_root.queue_free()
