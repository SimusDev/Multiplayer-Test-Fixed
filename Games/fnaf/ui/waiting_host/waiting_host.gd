extends Control

func _enter_tree() -> void:
	visible = not SD_Multiplayer.is_server()
