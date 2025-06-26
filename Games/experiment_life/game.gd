extends Node
class_name EL_Game

var _instance: EL_Game = null

func _enter_tree() -> void:
	_instance = self

func _exit_tree() -> void:
	_instance = null

func get_instance() -> EL_Game:
	return _instance
