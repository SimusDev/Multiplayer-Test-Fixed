class_name SourceConnectedPeerPrefab extends Control

@export var peer_player_name:String = "name"

@onready var name_label = get_node("name")

func _ready() -> void:
	_update()

func _update():
	name_label.text = peer_player_name
