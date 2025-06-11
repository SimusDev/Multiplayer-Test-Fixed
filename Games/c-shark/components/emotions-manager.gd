extends Node
class_name EmotionsManager

@export var model_to_animate:W_AnimatedModel3D  

var is_emotion_playing:bool = false
var current_animation:String

func _ready() -> void:
	model_to_animate.player.animation_finished.connect(animation_finished)
	setup()

func animation_finished(anim_name:String):
	set_emotion_playing(false)

func set_emotion_playing(value):
	is_emotion_playing = value

func setup():
	for child in get_children():
		if child is Emotion:
			child.setup()
