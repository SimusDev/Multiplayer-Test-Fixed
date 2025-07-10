class_name SourceProp extends Node

signal drag

@export var surface:String
@export var rigid_body:RigidBody3D
const synced_property_scene:PackedScene = preload("res://Games/source_game/game/prefabs/mp_property_transform.tscn")

var is_drag:bool = false
var drag_target:Node3D = null


func _ready() -> void:
	if !is_instance_valid(rigid_body):
		rigid_body = get_parent() as RigidBody3D
	drag.connect(_on_drag_syncronized)
	
	rigid_body.freeze = SD_Multiplayer.is_not_server()
	rigid_body.can_sleep = SD_Multiplayer.is_not_server()
	
	if synced_property_scene:
		var synced_property:SD_MPPropertySynchronizer = synced_property_scene.instantiate()
		rigid_body.add_child.call_deferred(synced_property)

func _process(delta: float) -> void:
	if is_drag and drag_target:
		if SD_Multiplayer.is_server():
			rigid_body.global_position = lerp(rigid_body.global_position, drag_target.global_position, 50 * delta)
			rigid_body.global_rotation_degrees = drag_target.global_rotation_degrees

func _on_drag_syncronized(value:bool, target:Node3D):
	SD_Multiplayer.sync_call_function(self, _on_drag, [value, target])


func _on_drag(value:bool, target:Node3D):
	is_drag = value
	drag_target = target
	rigid_body.gravity_scale = float(!value)
	
	if SD_Multiplayer.is_not_server(): return
	rigid_body.freeze = is_drag
	rigid_body.position = rigid_body.position * float(!is_drag)
