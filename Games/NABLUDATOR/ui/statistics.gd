extends Control

var _players: Dictionary[SD_NetworkPlayer, Control] = {}

func _ready() -> void:
	SD_Network.singleton.on_player_connected.connect(_player_connected)
	SD_Network.singleton.on_player_disconnected.connect(_player_disconnected)

func _player_connected(player: SD_NetworkPlayer) -> void:
	if player in _players:
		return

func _player_disconnected(player: SD_NetworkPlayer) -> void:
	if !player in _players:
		return
	
	
