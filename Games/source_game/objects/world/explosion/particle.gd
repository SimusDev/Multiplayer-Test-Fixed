extends Node3D

@export var size: float = 1.0

@export var sounds: Array[AudioStream] = []

var _anim_finished: bool = false
var _sound_finished: bool = false

func _ready() -> void:
	scale = Vector3(size, size, size)
	
	%AudioStreamPlayer3D.stream = sounds.pick_random()
	%AudioStreamPlayer3D.play()
	%AnimationPlayer.play("anim")


func _process(delta: float) -> void:
	if _anim_finished and _sound_finished:
		queue_free()
		set_process(false)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_anim_finished = true

func _on_audio_stream_player_3d_finished() -> void:
	_sound_finished = true
