extends SD_NetTrunk
class_name SD_NetTrunkNetworkProcessor

var _network: MultiplayerAPI
var _peer: MultiplayerPeer

func _initialized() -> void:
	singleton.on_active_status_changed.connect(_on_active_status_changed)
	set_process(singleton.is_active() and singleton.settings.custom_poll)

func _process(delta: float) -> void:
	_peer.poll()
	
	for id: int in _peer.get_available_packet_count():
		_peer.get_packet()

func _on_active_status_changed(status: bool) -> void:
	_network = multiplayer
	_peer = multiplayer.multiplayer_peer
	set_process(singleton.is_active() and singleton.settings.custom_poll)
	
