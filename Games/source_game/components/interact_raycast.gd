class_name SourceInteractRaycast extends RayCast3D

signal collider_changed
signal object_detected(obj)

@export var player:Node3D
@export var drag_item_link_node:Node3D
var is_drag_item:bool = false

var collider:Node3D = null : set = set_collider
var current_object = null

func _ready() -> void:
	SD_Network.register_object(self)
	

func _exit_tree() -> void:
	if is_drag_item and current_object:
		drag_prop(current_object)

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority() and not SimusDev.ui.has_active_interface():
		return
	
	if event is InputEventKey and current_object and event.is_released():
		var source_prop_component = current_object.get_node("SourceProp") as SourceProp
		if is_instance_valid(source_prop_component):
			source_prop_component.key_pressed.emit(event.as_text().to_lower())
	
	if is_drag_item:
		if Input.is_action_pressed("rotate_item"):
			if player.camera.enabled: player.camera.enabled = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			if event is InputEventMouseMotion:
				var sens:float = 1.0 * 0.25
				
				var rot_x = -event.relative.y
				var rot_y = -event.relative.x
				
				drag_item_link_node.rotation_degrees.x += rot_x * sens
				drag_item_link_node.rotation_degrees.y += rot_y * sens
		else:
			if not player.camera.enabled: player.camera.enabled = true


func set_collider(_collider:Variant):
	collider = _collider
	collider_changed.emit(collider)
	if not is_instance_valid(SourcePlayerUI.instance): return

	if !_collider or _collider is SourcePlayer:
		current_object = null
		return
	
	if _collider.is_in_group("props"):
		detect_object(_collider)

func _process(_delta: float) -> void:
	if !is_multiplayer_authority():
		return
	set_collider(get_collider())

func detect_object(obj:RigidBody3D):
	if Input.is_action_just_pressed("interact") and is_instance_valid(current_object):
		drag_prop(current_object)
	
	if current_object == obj: return
	current_object = obj
	object_detected.emit(obj)

#drug

func drag_prop(object:RigidBody3D):
	if not is_instance_valid(current_object): return
	var source_prop_component = current_object.get_node("SourceProp") as SourceProp
	if not is_instance_valid(source_prop_component): return
	
	drag_item_link_node.tree_exited.connect( func(): source_prop_component.drag.emit(!source_prop_component.is_drag, drag_item_link_node))
	drag_item_link_node.global_position = get_collision_point()
	drag_item_link_node.global_rotation_degrees = source_prop_component.rigid_body.global_rotation_degrees
	source_prop_component.drag.emit(!source_prop_component.is_drag, drag_item_link_node)
	is_drag_item = source_prop_component.is_drag

func detect_entity(ent:Node3D):
	if !is_multiplayer_authority():
		return

#OHALERA #GG #DELETE GODOT ENGINE 
#😘👍😂😍👌👌👌👌❤❤️❤️❤❤❤❤❤❤❤❤️😊😒🙌🙌🤣💕


#
