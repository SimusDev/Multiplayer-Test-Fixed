extends Node3D
class_name SB_EntitySimpleFootSteps

@export var streams: Array[AudioStream] = []
@export var bus: String = "game"

@export var animated_model: W_AnimatedModel3D
@export var animated_model_event: String = "footstep"
@export var volume_db: float = -30.0

func _ready() -> void:
	if animated_model:
		animated_model.event.connect(_on_event)

func _on_event(code: String, value: Variant) -> void:
	if animated_model_event == code:
		play()

func play() -> void:
	if streams.is_empty():
		return
	
	var picked: AudioStream = streams.pick_random()
	var audio := AudioStreamPlayer3D.new()
	audio.stream = picked
	audio.bus = bus
	audio.autoplay = true
	audio.volume_db = volume_db
	audio.finished.connect(audio.queue_free)
	add_child(audio)
	
	
