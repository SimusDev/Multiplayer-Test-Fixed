extends Resource
class_name R_AnimationHook

var target: Object
var animator: SourceItemAnimator

@export var animations: Array[StringName]

@export var apply_randomly:bool = false
@export var play_backwards:bool = false
@export var play_instant: bool = true

func init() -> void:
	pass

func apply(idx:int = 0) -> void:
	if animations.is_empty():
		return
	
	var animation = animations[idx]
	
	if not animation or not animator.player.has_animation(animation):
		return
	
	if animator.player.is_playing() and (not play_instant):
		return
	
	animator.player.stop()
	if play_backwards:
		animator.player.play_backwards(animation)
	else:
		animator.player.play(animation)

func apply_random() -> void:
	apply(randi_range(0, animations.size()-1))

static func initialize_from(array: Array[R_AnimationHook], _animator: SourceItemAnimator, _target: Object) -> void:
	if Engine.is_editor_hint():
		return
	
	var new: Array[R_AnimationHook] = []
	
	for i in array:
		new.append(i.duplicate())
	
	array.clear()
	array.append_array(new)
	
	for i in array:
		i.animator = _animator
		i.target = _target
		i.init()
