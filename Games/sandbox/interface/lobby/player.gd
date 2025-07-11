extends Control

func _ready() -> void:
	var player: SD_MultiplayerPlayer = SD_Multiplayer.get_player_by_peer_id(get_multiplayer_authority())
	if !player:
		return
	
	$SD_Label.text = player.get_username()
	
