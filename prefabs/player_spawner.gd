extends Node3D

@export var spread: float = 1.0
@export var player_scene: PackedScene

var _players: Dictionary[int, WorldPlayer] = {}

func _ready() -> void:
	if not visible:
		return
	
	SimusDev.multiplayerAPI.player_connected.connect(add_player)
	SimusDev.multiplayerAPI.player_disconnected.connect(delete_player)
	
	for id in SimusDev.multiplayerAPI.get_connected_players():
		add_player(id)
	


func add_player(m_player: SD_MultiplayerPlayer) -> void:
	var peer: int = m_player.get_peer_id()
	var player: WorldPlayer = player_scene.instantiate() as WorldPlayer
	player._multiplayer_player = m_player
	player.name = str(peer)
	_players[peer] = player
	
	player.set_multiplayer_authority(peer)
	
	await get_parent().call_deferred("add_child", player)
	player.global_position = global_position
	player.position.x += SD_Random.get_rfloat_range(-spread, spread) 
	player.position.z += SD_Random.get_rfloat_range(-spread, spread) 

func delete_player(m_player: SD_MultiplayerPlayer) -> void:
	var peer: int = m_player.get_peer_id()
	var player: WorldPlayer = _players[peer]
	_players.erase(peer)
	player.queue_free()
