extends Node3D
class_name SourceEntityDoor

signal interacted(ray: SourceInteractRay)
signal interacted_on_server(ray: SourceInteractRay)

@export var status: bool = false : set = set_status

func _ready() -> void:
	SD_Network.register_object(self)
	

func _do_action_server(ray: SourceInteractRay) -> void:
	set_status(!status)

func set_status(new: bool) -> void:
	if !SD_Network.is_server():
		return
	
	_set_status_net(new)
	SD_Network.call_func_except_self(_set_status_net, [new])
	

func _set_status_net(new: bool) -> void:
	print(new)

func _on_source_hitbox_interacted(ray: SourceInteractRay) -> void:
	interacted.emit(ray)
	if SD_Network.is_server():
		_do_action_server(ray)
		interacted_on_server.emit(ray)
	
