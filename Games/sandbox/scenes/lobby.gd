extends Node

@export var lobby_player: PackedScene

var _players: Dictionary[SD_MultiplayerPlayer, Control] = {}

func _ready() -> void:
	$Button.visible = SD_Multiplayer.is_server()
	
	if SD_Multiplayer.is_not_server():
		return
	
	SD_Multiplayer.get_singleton().player_connected.connect(_on_player_connected)
	SD_Multiplayer.get_singleton().player_disconnected.connect(_on_player_disconnected)
	
	for p in SD_Multiplayer.get_connected_players():
		_on_player_connected(p)

func _on_player_connected(player: SD_MultiplayerPlayer) -> void:
	var instance: Control = lobby_player.instantiate()
	instance.set_multiplayer_authority(player.get_peer_id())
	_players[player] = instance
	%GridContainer.add_child(instance)
	

func _on_player_disconnected(player: SD_MultiplayerPlayer) -> void:
	var node: Node = _players.get(player)
	if node:
		node.queue_free()

func _on_button_pressed() -> void:
	SB_SceneHolder.change_scene_with_base_path("game")
