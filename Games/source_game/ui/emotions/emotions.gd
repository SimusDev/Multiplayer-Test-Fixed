extends Control

@export var _container: Control

@export var emotion_scene: PackedScene

func set_emotions(emotions: SourceEmotions) -> void:
	if not emotions.resource:
		return
	
	for i in emotions.resource.list:
		var ui: Button = emotion_scene.instantiate() as Button
		ui.pressed.connect(_on_emotion_pressed.bind(emotions, i))
		ui.resource = i
		ui.emotions = emotions
		_container.add_child(ui)

func _on_emotion_pressed(emotions: SourceEmotions, res: R_SourceEmotion) -> void:
	res.try_use(emotions)
