extends Node3D

@export var authority_node:Node
@onready var label = get_node("label")

func _ready() -> void:
	update()

func update():
	var mp_player: SD_MultiplayerPlayer = SD_MultiplayerPlayer.find_in_node(authority_node)
	if mp_player:
		label.text = mp_player.get_username() #EZ
# WW
