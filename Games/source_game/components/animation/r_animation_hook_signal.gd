extends R_AnimationHook
class_name R_AnimationHookSignal

@export var name: StringName

func init() -> void:
	target.connect(name, apply)

static func create(signal_name: String, animation_names: Array[StringName] = []) -> R_AnimationHookSignal:
	var a := R_AnimationHookSignal.new()
	a.name = signal_name
	a.animations = animation_names
	return a
