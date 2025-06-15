extends Node
class_name Emotion

signal used

@export var animation_file:Animation
@export var animation_tree_property_path:String
@export var _name:String
@export var key_bind:String

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority():
		return

	if !event is InputEventKey:
		return
	
	if event.as_text_keycode().to_lower() == key_bind and event.is_pressed():
		SD_Multiplayer.sync_call_function(self, emit_signal_synced)

func setup():
	if !get_parent() is EmotionsManager:
		return
	
	get_parent().model_to_animate.player.get_animation_library("anim_library").add_animation(_name, animation_file)
	used.connect(animate)

func emit_signal_synced():
	used.emit()

func animate():
	var emotions_manager:EmotionsManager = get_parent()
	emotions_manager.reset()
	
	emotions_manager.current_animation = _name
	emotions_manager.set_emotion_playing(!emotions_manager.is_emotion_playing)
	emotions_manager.model_to_animate.get_animation_tree().set(animation_tree_property_path, emotions_manager.is_emotion_playing)
