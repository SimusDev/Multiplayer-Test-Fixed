extends Resource
class_name SB_EventPlayer

var peer_id: int = 0

var initialized: bool = false

func _init() -> void:
	if initialized:
		return
	
	initialized = true
	set_player(SD_Multiplayer.get_authority_player())

func get_player() -> SD_MultiplayerPlayer:
	return SD_Multiplayer.get_player_by_peer_id(peer_id)

func set_player(player: SD_MultiplayerPlayer) -> SB_EventPlayer:
	if !player:
		return self
	
	peer_id = player.get_peer_id()
	return self
