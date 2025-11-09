@icon("res://Games/source_game/components/vehicle/seat.png")
class_name SourceSeat extends Node3D

@export var enabled:bool = true

@export var dismount_action_key:StringName = "dismount"

@export_group("References")
@export var bind_point:Marker3D
@export var interactable:SourceInteractable

var sidyn4ik:Node3D

var caller:SD_NetFunctionCaller
var remote_transform:RemoteTransform3D

func _ready() -> void:
	set_process_input(false)
	
	SD_Network.register_object(self)
	SD_Network.register_function(_send)
	SD_Network.register_function(_recieve)
	SD_Network.register_function(set_movement_enabled)
	SD_Network.register_function(set_remote_transform_path)
	
	caller = SD_NetFunctionCaller.new()
	caller.default_channel = SourceNetwork.CHANNEL_INTERACTABLES
	add_child(caller)
	
	remote_transform = RemoteTransform3D.new()
	remote_transform.use_global_coordinates = true
	remote_transform.update_rotation = false
	add_child(remote_transform)
	remote_transform.global_position = bind_point.global_position
	
	if not SD_Network.is_server():
		caller.call_func_on_server(_send)
		return
	
	if is_instance_valid(interactable):
		interactable.on_interacted.connect(on_interactable_interacted)
	

func _send() -> void:
	var data:Dictionary = {}
	
	caller.call_func_on(SD_Network.get_remote_sender_id(), _recieve, [data, sidyn4ik])

func _recieve(data:Dictionary, sidyn:Node3D) -> void:
	sidyn4ik = sidyn
	set_remote_transform_path(sidyn)
	set_movement_enabled(sidyn4ik, false)

func on_interactable_interacted(interact_ray:SourceInteractRay) -> void:
	seat(interact_ray.root)
	

func seat(node:Node3D) -> void:
	sidyn4ik = node
	set_movement_enabled(node, false)
	caller.call_func(set_movement_enabled, [node, false])
	caller.call_func(set_remote_transform_path, [node])
	#МЯЧИК УБИЦА ! КРОВ

func dismount(node:Node3D) -> void:
	set_movement_enabled(node, true)
	caller.call_func(set_movement_enabled, [node, true])
	caller.call_func(set_remote_transform_path, [null])
	sidyn4ik = null
	#СЁКС

func set_remote_transform_path(node:Node3D) -> void:
	if not node:
		remote_transform.remote_path = NodePath()
		return
	sidyn4ik = node
	
	remote_transform.remote_path = remote_transform.get_path_to(node)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(dismount_action_key):
		dismount(sidyn4ik)

func set_movement_enabled(node:Node3D, value:bool) -> void:
	print("Node %s: , value: %s" % [node, value])
	
	if not node:
		return
	
	if SD_Network.is_player_and_authority(node):
		set_process_input(not value)
	
	var movement:W_FPCSourceLikeMovement = SD_Components.find_first(node, W_FPCSourceLikeMovement)
	if is_instance_valid(movement):
		if value:
			movement.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			movement.state_machine.switch_by_name("sitting")
			movement.process_mode = Node.PROCESS_MODE_DISABLED
			movement.actor.velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	if SD_Network.is_server():
		get_parent().position.z -= 0.1 * delta
