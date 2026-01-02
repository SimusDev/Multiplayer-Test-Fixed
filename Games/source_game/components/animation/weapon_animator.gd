@tool
extends SourceItemAnimator
class_name SourceWeaponAnimator

func _begin_reset() -> void:
	hooks.append(R_AnimationHookSignal.create("event_pick", [&"pick"]))
	hooks.append(R_AnimationHookSignal.create("event_fire", [&"fire"]))
	hooks.append(R_AnimationHookSignal.create("event_reload", [&"reload"]))
	hooks.append(R_AnimationHookSignal.create("event_inspect", [&"inspect"]))
	
	
	
