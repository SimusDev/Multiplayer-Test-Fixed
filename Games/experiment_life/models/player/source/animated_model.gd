@tool
extends W_AnimatedModel3D

@export var _movement: W_FPCSourceLikeMovement

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	
