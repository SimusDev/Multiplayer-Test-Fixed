extends Node

func finish_audio_and_queue_free(audio: Node) -> void:
	audio.queue_free()

func create_audio(stream: AudioStream, bus: String = "Master") -> AudioStreamPlayer:
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.stream = stream
	audio.bus = bus
	audio.finished.connect(finish_audio_and_queue_free.bind(audio))
	return audio

func create_audio_interface(stream: AudioStream) -> AudioStreamPlayer:
	return create_audio(stream, "interface")


func play_global_audio(stream:AudioStream, bus:String) -> void:
	var player = create_audio(stream, bus)
	add_child(player)
	player.play()
