extends Node
class_name AuthorityChecker

@export var camera: W_FPCSourceLikeCamera
@export var node:Node

func _ready() -> void:
	if !node.is_multiplayer_authority():
		node.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		if camera:
			camera.make_current()
