extends Node
class_name SB_PhysicsRagdoll

@export var root: Node
@export var _simulator: PhysicalBoneSimulator3D

func _ready() -> void:
	if !root:
		root = get_parent()
	
	_simulator.physical_bones_start_simulation()
	
	await get_tree().create_timer(10.0).timeout
