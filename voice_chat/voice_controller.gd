extends Node

@export var input_player: AudioStreamPlayer
@export var output_player: AudioStreamPlayer

var recording_effect = AudioEffectCapture.new()
var recording_bus_idx: int

func _ready():
	# Setup recording bus
	recording_bus_idx = AudioServer.get_bus_count()
	AudioServer.add_bus(recording_bus_idx)
	AudioServer.add_bus_effect(recording_bus_idx, recording_effect)
	input_player.bus = "Record"

func _input(event: InputEvent) -> void:
	if !is_multiplayer_authority(): return

	if Input.is_action_just_pressed("voice"):
		input_player.play()
	if Input.is_action_just_released("voice"):
		input_player.stop()

func _process(delta):
	if not input_player.playing:
		return
	
	var frames = recording_effect.get_buffer(recording_effect.get_frames_available())
	if frames.size() > 0:
		rpc("_receive_voice_data", frames)

@rpc("any_peer", "unreliable_ordered")
func _receive_voice_data(data: PackedVector2Array):
	# Create stream from received data and play it
	var stream = AudioStreamGenerator.new()
	stream.mix_rate = 44100
	output_player.stream = stream
	var playback = output_player.get_stream_playback()
	if !playback:
		playback = AudioStreamPlayback.new()
	playback.push_buffer(data)
	output_player.play()
