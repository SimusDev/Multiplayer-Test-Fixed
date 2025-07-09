class_name SourceInteractRaycast extends RayCast3D

signal collider_changed
signal object_detected(obj)

@export var player:SourcePlayer
@export var drag_item_link_node:Node3D
var collider:Node3D = null : set = set_collider
var current_object = null

func set_collider(_collider:Variant):
	collider = _collider
	collider_changed.emit(collider)
	if not is_instance_valid(SourcePlayerUI.instance): return
	
	SourcePlayerUI.get_instance().object_info.hide()
	if !_collider or _collider is SourcePlayer:
		current_object = null
		return
	
	if _collider.is_in_group("props"):
		SourcePlayerUI.get_instance().object_info.show()
		detect_object(_collider)

func _process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return
	set_collider(get_collider())

func detect_object(obj:RigidBody3D):
	show_object_info(obj)
	if Input.is_action_just_pressed("interact") and is_instance_valid(current_object):
		drag_prop(current_object)
	
	if current_object == obj: return
	current_object = obj
	object_detected.emit(obj)

func show_object_info(object:RigidBody3D):
	var object_info = SourcePlayerUI.get_instance().get_node("object_info")
	object_info.get_node("name_label").text = str(object.name)
	var camera = player.camera.camera
	var screen_pos = camera.unproject_position(object.global_position)
	object_info.position = screen_pos - Vector2(128, 128)

func drag_prop(object:RigidBody3D):
	var source_prop_component = current_object.get_node("SourceProp") as SourceProp
	drag_item_link_node.global_position = get_collision_point()
	source_prop_component.drag.emit(!source_prop_component.is_drag, drag_item_link_node)

func detect_entity(ent:Node3D):
	if !is_multiplayer_authority():
		return

#OHALERA 








#
