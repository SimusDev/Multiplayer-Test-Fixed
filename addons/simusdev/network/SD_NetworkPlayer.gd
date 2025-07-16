extends Node
class_name SD_NetworkPlayer

var resource: SD_NetPlayerResource
var _data: Dictionary = {}

var _peer: int = 1

func get_username() -> String:
	return _data.get("_username", "")

func get_nickname() -> String:
	return get_username()

func get_unique_id() -> int:
	return _peer

func get_peer_id() -> int:
	return _peer
