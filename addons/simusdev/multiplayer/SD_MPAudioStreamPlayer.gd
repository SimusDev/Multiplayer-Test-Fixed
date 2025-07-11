extends AudioStreamPlayer
class_name SD_MPAudioStreamPlayer

@export var streams: Array[AudioStream] = []

func _ready() -> void:
	synchronize_playback()

func synchronize_playback() -> void:
	SD_Multiplayer.sync_call_function_on_server(self, _send_playback_to_client, [SD_Multiplayer.get_unique_id()])

func _send_playback_to_client(peer: int) -> void:
	var args: Array = [
		stream,
		get_playback_position(),
		pitch_scale,
		volume_db,
		bus,
		stream_paused,
		
	]
	SD_Multiplayer.sync_call_function_on_peer(peer, self, _recieve_playback_from_server, [args])

func _recieve_playback_from_server(args: Array) -> void:
	stream = args[0]
	pitch_scale = args[2]
	volume_db = args[3]
	bus = args[4]
	stream_paused = args[5]
	
	play(args[1])

func _exit_tree() -> void:
	if SD_Multiplayer.is_server():
		if is_queued_for_deletion():
			SD_Multiplayer.sync_call_function_except_self(self, queue_free)

func sync_play(from: float = 0.0) -> void:
	var picked_stream: AudioStream
	if !streams.is_empty():
		picked_stream = streams.pick_random()
	
	if picked_stream:
		SD_Multiplayer.sync_call_function(self, __sync_play, [from, picked_stream])
	else:
		SD_Multiplayer.sync_call_function(self, play, [from])

func __sync_play(from: float, picked_stream: AudioStream) -> void:
	stream = picked_stream
	play(from)

func sync_seek(to: float) -> void:
	SD_Multiplayer.sync_call_function(self, seek, [to])

func sync_set_stream(new_stream: AudioStream) -> void:
	SD_Multiplayer.sync_call_function(self, set_stream, [new_stream])

func sync_set_pitch_scale(scale: float) -> void:
	SD_Multiplayer.sync_call_function(self, set_pitch_scale, [scale])

func sync_set_volume_db(volume: float) -> void:
	SD_Multiplayer.sync_call_function(self, set_volume_db, [volume])

func sync_set_bus(new_bus: String) -> void:
	SD_Multiplayer.sync_call_function(self, set_bus, [new_bus])

func sync_set_stream_paused(pause: bool) -> void:
	SD_Multiplayer.sync_call_function(self, set_stream_paused, [pause])
