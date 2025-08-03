@icon("res://addons/simusdev/icons/MultiplayerSpawner.svg")
extends Node
class_name SD_NetworkSpawner

@export var _initial_roots: Array[Node] = []

var _roots: Array[Node] = []

func _ready() -> void:
	pass

func add_root(root: Node) -> void:
	pass

func remove_root(root: Node) -> void:
	pass

func request_spawn_all() -> void:
	pass
