extends Control

@export var connected_peer_prefab:PackedScene
@export var peers_container:VBoxContainer

func _ready() -> void:
	SD_Multiplayer._singleton.peer_connected.connect(_on_peer_connected)
	SD_Multiplayer._singleton.peer_disconnected.connect(_on_peer_disconnected)
	_update()

func _on_peer_connected(peer_id:int): _update()
func _on_peer_disconnected(peer_id:int): _update()

func _clear_peers():
	for child in peers_container.get_children():
		child.queue_free()

func _update():
	_clear_peers()
	for peer:int in SD_Multiplayer.get_connected_peers():
		var player = SD_Multiplayer.get_player_by_peer_id(peer)
		_add_peer(player.get_username())

func _add_peer(peer_name:String):
	var new_peer_ui = connected_peer_prefab.instantiate() as SourceConnectedPeerPrefab
	new_peer_ui.peer_player_name = peer_name
	peers_container.add_child(new_peer_ui)
