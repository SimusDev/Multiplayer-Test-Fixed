extends Control

@export var _container: Control

@export var emotion_scene: PackedScene

func set_emotions(emotions: SourceEmotions) -> void:
	if not emotions.resource:
		return
	
	for i in emotions.resource.list:
		var ui: Control = emotion_scene.instantiate() as Control
		ui.resource = i
		ui.emotions = emotions
		_container.add_child(ui)
