@tool
extends Node
class_name A_ItemAnimation

@export var animator: SourceItemAnimator

@export var hook: R_AnimationHook

func _ready() -> void:
	if get_parent() is SourceItemAnimator:
		animator = get_parent()
	
