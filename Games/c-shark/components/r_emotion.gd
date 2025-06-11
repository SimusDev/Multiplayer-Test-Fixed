extends Node
class_name Emotion

signal used

@export var animation_file:Animation
@export var _name:String
@export var key_bind:String

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return
	
	if !event is InputEventKey:
		return
	
	if event.as_text_keycode() == key_bind:
		SD_Multiplayer.sync_call_function(self, emit_signal_synced)

func setup():
	if !get_parent() is EmotionsManager:
		return
	
	get_parent().model_to_animate.player.get_animation_library("anim_library").add_animation(_name, animation_file)
	used.connect(play)

func emit_signal_synced():
	used.emit()

func play():
	
	get_parent().set_emotion_playing(true)
	get_parent().model_to_animate.player.play("anim_library/"+_name)
