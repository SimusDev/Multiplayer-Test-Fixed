extends Control

@export var _container: VBoxContainer

@export var user_scene: PackedScene

var _players: Dictionary[SD_NetworkPlayer, Control] = {}

func _ready() -> void:
	SD_Network.singleton.on_player_connected.connect(_on_player_connected)
	SD_Network.singleton.on_player_disconnected.connect(_on_player_disconnected)
	
	for i in SD_Network.get_player_list():
		_on_player_connected(i)

func _on_player_connected(player: SD_NetworkPlayer) -> void:
	var ui: Control = user_scene.instantiate()
	_container.add_child(ui)
	ui.init(player)
	_players[player] = ui

func _on_player_disconnected(player: SD_NetworkPlayer) -> void:
	var ui: Control = _players[player]
	ui.queue_free()
	_players.erase(player)
