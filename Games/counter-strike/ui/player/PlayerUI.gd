extends CanvasLayer
#class_name PlayerUI

@export var player: CS_Player

func _ready() -> void:
	set_multiplayer_authority(player.get_multiplayer_authority())
