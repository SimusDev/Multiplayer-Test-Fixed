extends Node
class_name SB_Game

var _instance: SB_Game = null

func _enter_tree() -> void:
	_instance = self

func _exit_tree() -> void:
	_instance = null

func get_instance() -> SB_Game:
	return _instance
