extends Node3D

@export var authority_node:Node
@onready var label = get_node("label")

func _ready() -> void:
	update()

func update():
	var mp_player: SD_NetworkPlayer = SD_NetworkPlayer.find_in(authority_node)
	if mp_player:
		label.text = mp_player.get_username()
# WW
