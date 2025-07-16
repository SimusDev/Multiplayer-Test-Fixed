class_name ZV_MultiplayerChat extends Node

var instance
var player_color:Color = Color(1, 1, 1, 1)

func _init() -> void:
	if is_multiplayer_authority():
		instance = self
