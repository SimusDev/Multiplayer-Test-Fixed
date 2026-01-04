@static_unload
extends RefCounted
class_name SimusNetConnectionENet

static func create_server(port: int, max_clients: int = 32) -> void:
	SimusNetConnection.try_close_peer()
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(port, max_clients)
	SimusNetConnection.set_peer(peer)

static func create_client(address: String, port: int) -> void:
	SimusNetConnection.try_close_peer()
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	SimusNetConnection.set_peer(peer)
