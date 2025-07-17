extends Control

@export var connected_peer_prefab:PackedScene
@export var peers_container:VBoxContainer

func _ready() -> void:
	SD_Multiplayer._singleton.player_connected.connect(_on_player_connected)
	SD_Multiplayer._singleton.player_disconnected.connect(_on_player_disconnected)
	_update()

func _on_player_connected(player:SD_MultiplayerPlayer): _update()
func _on_player_disconnected(player:SD_MultiplayerPlayer): _update()

func _clear_players():
	for child in peers_container.get_children():
		child.queue_free()

func _update():
	_clear_players()
	for player:SD_MultiplayerPlayer in SD_Multiplayer.get_connected_players():
		_add_player(player.get_username())

func _add_player(peer_name:String):
	var new_peer_ui = connected_peer_prefab.instantiate() as SourceConnectedPeerPrefab
	new_peer_ui.peer_player_name = peer_name
	peers_container.add_child(new_peer_ui)
