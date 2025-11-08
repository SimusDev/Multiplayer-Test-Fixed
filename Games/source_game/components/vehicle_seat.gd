@icon("res://Games/source_game/components/vehicle/seat.png")
class_name SourceSeat extends Node

@export var enabled:bool = true

@export_group("References")
@export var bind_point:Marker3D
@export var interactable:SourceInteractable

var sidyn4ik:Node3D
var caller:SD_NetFunctionCaller

func _ready() -> void:
	SD_Network.register_object(self)
	SD_Network.register_function(_send)
	SD_Network.register_function(_recieve)
	SD_Network.register_function(set_movement_enabled)
	
	caller = SD_NetFunctionCaller.new()
	caller.default_channel = SourceNetwork.CHANNEL_INTERACTABLES
	add_child(caller)
	
	
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
	set_movement_enabled(sidyn4ik, false)

func on_interactable_interacted(interact_ray:SourceInteractRay) -> void:
	if sidyn4ik == interact_ray.root:
		dismount(sidyn4ik)
	else:
		seat(interact_ray.root)

func seat(node:Node3D) -> void:
	caller.call_func(set_movement_enabled, [node, false])
	node.global_position = bind_point.global_position
	#МЯЧИК УБИЦА ! КРОВ

func dismount(node:Node3D) -> void:
	caller.call_func(set_movement_enabled, [node, true])

func set_movement_enabled(node:Node3D, value:bool) -> void:
	if not node:
		return
	
	var movement:W_FPCSourceLikeMovement = SD_Components.find_first(node, W_FPCSourceLikeMovement)
	if is_instance_valid(movement):
		if value:
			movement.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			movement.process_mode = Node.PROCESS_MODE_DISABLED
