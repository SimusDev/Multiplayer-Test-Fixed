extends Node
class_name GameWorld

static var _instance: GameWorld

func _enter_tree() -> void:
	_instance = self

func _exit_tree() -> void:
	_instance = null

static func get_instance() -> GameWorld:
	return _instance
