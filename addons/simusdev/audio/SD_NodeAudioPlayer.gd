@icon("res://addons/simusdev/icons/AudioStreamPlayer.svg")
extends Node
class_name SD_NodeAudioPlayer

@export var default_bus: String = "Master"

func create(stream: AudioStream = null, parent: Node = SimusDev) -> AudioStreamPlayer:
	var audio := AudioStreamPlayer.new()
	audio.stream = stream
	audio.bus = default_bus
	audio.finished.connect(audio.queue_free)
	parent.add_child(audio)
	return audio
