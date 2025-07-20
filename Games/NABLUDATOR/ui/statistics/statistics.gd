extends Control

var _players: Dictionary[SD_NetworkPlayer, Control] = {}

@export var scene: PackedScene

@onready var v_box_container: VBoxContainer = $panel_default/ScrollContainer/VBoxContainer

func _ready() -> void:
	SD_Network.singleton.on_player_connected.connect(_player_connected)
	SD_Network.singleton.on_player_disconnected.connect(_player_disconnected)
	
	for player in SD_Network.get_player_list():
		_player_connected(player)

func _player_connected(player: SD_NetworkPlayer) -> void:
	if player in _players:
		return
	
	var ui: Control = scene.instantiate() as Control
	ui.player = player
	v_box_container.add_child(ui)
	

func _player_disconnected(player: SD_NetworkPlayer) -> void:
	if !player in _players:
		return
	
	var ui: Control = _players.get(player) as Control
	ui.queue_free()
	
