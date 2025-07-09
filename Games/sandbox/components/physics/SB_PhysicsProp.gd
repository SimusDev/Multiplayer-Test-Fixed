extends Node
class_name SB_PhysicsProp

@export var _source: Node3D

func _ready() -> void:
	if not _source:
		return
	
	await _source.ready
	
	var transform_sync: PackedScene = SB_GameSingleton.instance.prefabs.p_sync_transform
	
	_source.add_child(transform_sync.instantiate())
	
	if _source is RigidBody3D:
		_source.freeze = SD_Multiplayer.is_not_server()
