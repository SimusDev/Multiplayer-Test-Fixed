extends Node
class_name C_DestroyComponent

@export var target: Node

func destroy() -> void:
	if multiplayer.is_server():
		_destroy_rpc_.rpc()

@rpc("any_peer", "call_local", "reliable")
func _destroy_rpc_() -> void:
	target.call_deferred("queue_free")
