@tool 
extends RayCast3D
class_name SourceInteractRay

const LAYERS: PackedInt32Array = [
	1,
	2,
	4,
]

@export var root: Node
var player: bool = false
@export var input: StringName = "source.interact"

@export var server_authority: bool = true

const RAY_POSITION: Vector3 = Vector3(0, 0, -3.0)

signal interacted(object: Object)

func _ready() -> void:
	target_position = RAY_POSITION
	
	
	
	if not root:
		root = get_parent()
	
	if !Engine.is_editor_hint():
		SD_Components.append_to(root, self)
		SD_Network.register_object(self)
		SD_Network.register_functions([
			_interact_server,
		])
		return
	
	
	player = root is SourcePlayer
	
	
	if not Engine.is_editor_hint():
		if not SD_Network.is_server():
			if player == false:
				SD_Nodes.fast_queue_free(self)
				return
			
			enabled = false
			hide()
			
			return
	
	if not Engine.is_editor_hint():
		set_process_input(SD_Network.is_authority(self) and player)
		set_process_unhandled_input(false)
	
	collide_with_areas = true
	collide_with_bodies = true
	
	set_collision_mask_value(1, false)
	for layer in LAYERS:
		set_collision_mask_value(layer, true)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(input):
		if SimusDev.ui.has_active_interface():
			return
		try_interact()

func try_interact() -> void:
	SD_Network.call_func_on_server(_interact_server)

func _interact_server() -> void:
	var object: Object = get_collider()
	_interact_net(object)
	
	if object is Node:
		SD_Network.call_func_except_self(_interact_net, [object])

func _interact_net(object: Object) -> void:
	if !is_instance_valid(object):
		return
	
	if player:
		S_EventInteract.as_event().player = root
	S_EventInteract.as_event().source = root
	S_EventInteract.as_event().object = object
	S_EventInteract.as_event().ray = self
	S_EventInteract.as_event().publish()
