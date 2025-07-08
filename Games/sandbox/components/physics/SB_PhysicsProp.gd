extends Node
class_name SB_PhysicsProp

@export var _source: Node3D

func _ready() -> void:
	if not _source:
		return
	
	if _source is RigidBody3D:
		_source.freeze = SD_Multiplayer.is_not_server()
