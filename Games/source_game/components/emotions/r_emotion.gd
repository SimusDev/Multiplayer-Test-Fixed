extends Resource
class_name R_SourceEmotion

@export var name: StringName = ""
@export var animation: StringName = ""
@export var sound: R_SourceSound

func try_use(emotions: SourceEmotions) -> void:
	if sound:
		sound.try_play(emotions.root)
	
	if animation:
		emotions.play_animation(animation)
	
	_use(emotions.root)

func _use(root: Node3D) -> void:
	pass
