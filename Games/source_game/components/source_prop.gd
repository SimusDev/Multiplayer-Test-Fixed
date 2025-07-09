class_name SourceProp extends Node

@export var surface:String
@export var rigid_body:RigidBody3D
@export var is_static:bool = false
const synced_property_scene:PackedScene = preload("res://Games/source_game/game/prefabs/mp_property_transform.tscn")

func _ready() -> void:
	if !is_instance_valid(rigid_body):
		rigid_body = get_parent() as RigidBody3D
	
	rigid_body.freeze = SD_Multiplayer.is_not_server()
	rigid_body.can_sleep = SD_Multiplayer.is_not_server()
	
	if SD_Multiplayer.is_server(): rigid_body.freeze = is_static
	
	if synced_property_scene:
		var synced_property:SD_MPPropertySynchronizer = synced_property_scene.instantiate()
		rigid_body.add_child.call_deferred(synced_property)
