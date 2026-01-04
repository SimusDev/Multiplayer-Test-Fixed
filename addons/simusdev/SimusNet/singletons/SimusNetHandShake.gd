extends SimusNetSingletonChild
class_name SimusNetHandShake

static var _instance: SimusNetHandShake

func initialize() -> void:
	_instance = self

static func _api_connected_to_server() -> void:
	_instance._on_connected_to_server()

func _on_connected_to_server() -> void:
	_server_send.rpc_id(SimusNetConnection.SERVER_ID)

@rpc("any_peer", "call_remote", "reliable", SimusNetChannels.BUILTIN.HANDSHAKE)
func _server_send() -> void:
	var data: Dictionary = {
		"cache" : SimusNetCache.get_data()
	}
	
	_client_recieve.rpc_id(multiplayer.get_remote_sender_id(), SimusNetCompressor.parse_gzip(data))

@rpc("authority", "call_remote", "reliable", SimusNetChannels.BUILTIN.HANDSHAKE)
func _client_recieve(bytes: PackedByteArray) -> void:
	var data: Dictionary = SimusNetDecompressor.parse_gzip(bytes)
	SimusNetCache._set_data(data.cache)
	
	SimusNetEvents.event_connected.publish()
