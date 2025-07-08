extends Node
class_name EL_PhysicsProp

@export var _source: Node3D

func _ready() -> void:
	if not _source:
		return
	
	if _source is RigidBody3D:
		_source.freeze = 
