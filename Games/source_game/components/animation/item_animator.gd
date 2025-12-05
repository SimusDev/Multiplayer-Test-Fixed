@tool
class_name SourceItemAnimator extends Node

@export var _reset: bool = false : set = reset

@export var hooks: Array[R_AnimationHook] = []
@export var player: AnimationPlayer
var item: SourceItem

@export var initialized: bool = false

func reset(val: bool = true) -> void:
	hooks.clear()
	for i in get_children():
		queue_free()
	
	_begin_reset()

func _begin_reset() -> void:
	pass
	

func _ready() -> void:
	if not initialized:
		reset()
		initialized = true
	
	if Engine.is_editor_hint():
		return
	
	item = SourceItem.find_above(self)
	
	R_AnimationHook.initialize_from(hooks, self, item)
