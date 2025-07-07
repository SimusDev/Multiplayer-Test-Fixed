class_name SourceProp extends Node

@export var rigid_body:RigidBody3D
const synced_property_scene:PackedScene = preload("res://Games/source_game/game/prefabs/mp_property_transform.tscn")

func _ready() -> void:
	rigid_body.freeze = SD_Multiplayer.is_not_server()
	rigid_body.can_sleep = SD_Multiplayer.is_not_server()
	
	var synced_property:SD_MPPropertySynchronizer = synced_property_scene.instantiate()
	rigid_body.add_child.call_deferred(synced_property)
