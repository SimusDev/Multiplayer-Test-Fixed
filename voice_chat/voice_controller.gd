extends Node

@export var input_key: String = "voice"
@export var broadcast_interval: float = 0.1

@onready var output: AudioStreamPlayer = $output
@onready var input: AudioStreamPlayer = $input

var effect: AudioEffectCapture
var recording_playback: AudioStreamGeneratorPlayback
var is_recording := false
var broadcast_timer: float = 0.0

func _ready():
	setup_audio()
	set_multiplayer_authority(str(name).to_int())

func _process(delta):
	if not is_multiplayer_authority(): return
	
	if is_recording:
		broadcast_timer += delta
		if broadcast_timer >= broadcast_interval:
			broadcast_timer = 0.0
			broadcast_audio()

func setup_audio():
	# Setup audio input
	var idx = AudioServer.get_bus_index("record")
	effect = AudioServer.get_bus_effect(idx, 0) as AudioEffectCapture
	
	# Setup audio output
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = 44100
	generator.buffer_length = 0.1
	
	output.stream = generator
	output.play()
	recording_playback = output.get_stream_playback()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(input_key): start_recording()
	if Input.is_action_just_released(input_key): stop_recording()

func start_recording():
	if is_recording: return
		
	is_recording = true
	effect.clear_buffer()
	input.play()

func stop_recording():
	if !is_recording: return
		
	is_recording = false
	input.stop()

func broadcast_audio():
	if not is_recording: return
	
	var available_frames = effect.get_frames_available()
	if available_frames == 0: return
	
	# Correct way to get buffer data
	var stereo_buffer = PackedVector2Array()
	stereo_buffer.resize(available_frames)
	
	# Get buffer returns number of frames actually read
	var frames_read = effect.get_buffer(stereo_buffer)
	
	# If we got data, process it
	if frames_read > 0:
		# Play locally with echo effect
		var echo_buffer = stereo_buffer.slice(0, frames_read)
		#recording_playback.push_buffer(echo_buffer)
		
		# Send to other players
		var audio_data = echo_buffer.to_byte_array()
		SD_Network.call_func_except_self(receive_audio, [audio_data], SD_Network.CALLMODE.UNRELIABLE_ORDERED)

func receive_audio(audio_data: PackedByteArray):
	
	var stereo_buffer = PackedVector2Array()
	stereo_buffer.resize(audio_data.size() / 8)
	stereo_buffer.set_from_byte_array(audio_data)
	
	recording_playback.push_buffer(stereo_buffer)
