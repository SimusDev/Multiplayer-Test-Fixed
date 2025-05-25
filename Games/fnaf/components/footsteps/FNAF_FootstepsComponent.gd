extends Node
class_name FNAF_FootstepsComponent

@export var camera: W_FPCSourceLikePlayerCamera
@export var movement: W_FPCSourceLikeMovement
@export var audio: AudioStreamPlayer3D
@export var streams: Array[AudioStream]

func _ready() -> void:
	movement.state_machine.transitioned.connect(_on_sm_transitioned)
	camera.bob_footstep.connect(_on_bob_footstep)

func _on_sm_transitioned(from: SD_State, to: SD_State) -> void:
	if is_multiplayer_authority():
		match to.name:
			"jump":
				play_sound_synced()


func play_sound() -> void:
	if streams.is_empty():
		return
	
	var picked_stream: AudioStream = streams.pick_random()
	audio.stream = picked_stream
	audio.play()

func play_sound_synced() -> void:
	SD_Multiplayer.sync_call_function(self, play_sound)

func _on_bob_footstep() -> void:
	play_sound_synced()
