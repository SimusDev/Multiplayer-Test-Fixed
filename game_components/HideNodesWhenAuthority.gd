extends Node

@export var hide_at_start: bool = false
@export var nodes: Array[Node]

func _ready() -> void:
	if hide_at_start:
		hide_nodes()

func hide_nodes() -> void:
	for node in nodes:
		if node.is_multiplayer_authority() and node.has_method("hide"):
				node.hide()
