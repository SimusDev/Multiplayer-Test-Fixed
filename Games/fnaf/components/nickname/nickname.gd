extends Node3D

@export var player: FNAF_Player

func _ready() -> void:
	visible = !player.is_multiplayer_authority()
	var mp_player: SD_MultiplayerPlayer = SD_MultiplayerPlayer.find_in_node(player)
	$Label3D.text = mp_player.get_username()
