extends Node

func _ready() -> void:
	SD_Network.register_all_functions(self)
	SD_Network.register_object(self)

func finish_audio_and_queue_free(audio: Node) -> void:
	audio.queue_free()

func create_audio(stream: AudioStream, bus: String = "Master") -> AudioStreamPlayer:
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.stream = stream
	audio.bus = bus
	audio.finished.connect(finish_audio_and_queue_free.bind(audio))
	return audio

func create_audio_3d(stream: AudioStream, bus: String = "Master") -> AudioStreamPlayer3D:
	var audio: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	audio.stream = stream
	audio.bus = bus
	audio.finished.connect(finish_audio_and_queue_free.bind(audio))
	return audio

func create_audio_interface(stream: AudioStream) -> AudioStreamPlayer:
	return create_audio(stream, "interface")

func play_global_audio(stream:AudioStream, bus:String = "Master") -> void:
	var player = create_audio(stream, bus)
	add_child(player)
	player.play()

func play_global_audio_3d(position:Vector3 , stream:AudioStream, bus:String = "Master", volume:float = 0.0, max_distance:float = 0.0) -> void:
	var player3d = create_audio_3d(stream, bus)
	player3d.volume_db = volume
	player3d.max_distance = max_distance
	add_child(player3d)
	player3d.global_position = position
	player3d.play()
