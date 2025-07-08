extends Node
class_name SB_SceneHolder

var _instance: SB_SceneHolder

@export var start_scene: PackedScene

func _enter_tree() -> void:
	_instance = self

func _exit_tree() -> void:
	_instance = null

func _ready() -> void:
	pass
