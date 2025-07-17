class_name MultiplayerUI extends Control

var instance
var player_color:Color = Color(1, 1, 1, 1)

func _enter_tree() -> void:
	instance = self
