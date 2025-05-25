extends AudioStreamPlayer2D
class_name SD_MPSyncedAudioStreamPlayer2D

func _ready() -> void:
	synchronize_playback()

func synchronize_playback() -> void:
	if !multiplayer.is_server():
		_address_to_peer_and_sync_playback.rpc_id(SD_MultiplayerSingleton.HOST_ID)

@rpc("any_peer", "reliable")
func _address_to_peer_and_sync_playback() -> void:
	var stream_path: String = ""
	if stream:
		stream_path = stream.resource_path
	_recieve_audio_position_and_play.rpc_id(multiplayer.get_remote_sender_id(), playing, get_playback_position(), stream_path)

@rpc("any_peer", "reliable")
func _recieve_audio_position_and_play(is_playing: bool, pos: float, stream_path: String) -> void:
	if not stream_path.is_empty():
		stream = load(stream_path)
	
	if is_playing:
		play(pos)

func play_synced(from_pos: float = 0.0) -> void:
	_play_synced_rpc.rpc(from_pos)

@rpc("any_peer", "call_local", "reliable")
func _play_synced_rpc(from_pos: float) -> void:
	play(from_pos)

func set_stream_synced(_stream: AudioStream) -> void:
	_set_stream_synced_rpc(_stream.resource_path)

@rpc("any_peer", "call_local", "reliable")
func _set_stream_synced_rpc(stream_path: String) -> void:
	var loaded_stream: AudioStream = load(stream_path)
	stream = loaded_stream
	
