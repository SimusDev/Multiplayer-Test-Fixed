extends Node
class_name EL_PlayerComponent

@export var source: Node

func _enter_tree() -> void:
	source.set_meta("EL_PlayerComponent", self)

func get_source() -> Node:
	return source

static func find_in(node: Node) -> EL_PlayerComponent:
	if node.has_meta("EL_PlayerComponent"):
		return node.get_meta("EL_PlayerComponent")
	return null
