extends Node
class_name EmotionsManager

@export var model_to_animate:W_AnimatedModel3D  

var is_emotion_playing:bool = false

func _ready() -> void:
	model_to_animate.player.animation_finished.connect(set_emotion_playing.bind(false))
	setup()

func set_emotion_playing(value):
	is_emotion_playing = value

func setup():
	for child in get_children():
		if child is Emotion:
			child.setup()
